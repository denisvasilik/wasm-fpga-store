PWD=$(shell pwd)

all: package

prepare:
	@mkdir -p work

project: prepare hxs
	@vivado -mode batch -source scripts/create_project.tcl -notrace -nojournal -tempDir work -log work/vivado.log

package: prepare hxs
	@vivado -mode batch -source scripts/package_ip.tcl -notrace -nojournal -tempDir work -log work/vivado.log

clean:
	@find ip ! -iname *.xci -type f -exec rm {} +
	@rm -rf .Xil vivado*.log vivado*.str vivado*.jou
	@rm -rf work \
		src-gen \
		hxs_gen
	@rm -rf ip/**/hdl \
		ip/**/synth \
		ip/**/example_design \
		ip/**/sim \
		ip/**/simulation \
		ip/**/misc \
		ip/**/doc

hxs:
	docker run -t \
               -v ${PWD}/hxs:/work/src \
               -v ${PWD}/hxs_gen:/work/gen \
               registry.build.aug:5000/docker/hxs_generator:latest

.PHONY: all prepare project package clean hxs
