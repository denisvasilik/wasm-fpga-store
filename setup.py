import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()

__tag__ = ""
__build__ = 0
__version__ = "{}".format(__tag__)
__commit__ = "0000000"

setuptools.setup(
    name="wasm-fpga-store",
    version=__version__,
    author="Denis Vasilìk",
    author_email="contact@denisvasilik.com",
    url="https://github.com/denisvasilik/wasm-fpga-store/",
    project_urls={
        "Bug Tracker": "https://github.com/denisvasilik/wasm-fpga/",
        "Documentation": "https://wasm-fpga.readthedocs.io/en/latest/",
        "Source Code": "https://github.com/denisvasilik/wasm-fpga-store/",
    },
    description="WebAssembly FPGA Store",
    long_description=long_description,
    long_description_content_type="text/markdown",
    packages=setuptools.find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3.6",
        "Operating System :: OS Independent",
    ],
    dependency_links=[],
    package_dir={},
    package_data={},
    data_files=[
        ("wasm-fpga-store/package", ["package/component.xml"]),
        ("wasm-fpga-store/package/bd", ["package/bd/bd.tcl"]),
        ("wasm-fpga-store/package/xgui", ["package/xgui/wasm_fpga_store_v1_0.tcl"]),
        (
            "wasm-fpga-store/resources",
            [
                "resources/wasm_fpga_store_header.vhd",
                "resources/wasm_fpga_store_direct.vhd",
                "resources/wasm_fpga_store_indirect.vhd",
                "resources/wasm_fpga_store_wishbone.vhd",
            ],
        ),
        (
            "wasm-fpga-store/ip/WasmFpgaTestBenchRam",
            ["ip/WasmFpgaTestBenchRam/WasmFpgaTestBenchRam.xci"],
        ),
        ("wasm-fpga-store/src", ["src/WasmFpgaStore.vhd"]),
        (
            "wasm-fpga-store/tb",
            [
                "tb/tb_FileIo.vhd",
                "tb/tb_pkg_helper.vhd",
                "tb/tb_pkg.vhd",
                "tb/tb_std_logic_1164_additions.vhd",
                "tb/tb_Types.vhd",
                "tb/tb_WasmFpgaStore.vhd",
                "tb/tb_WbRam.vhd",
            ],
        ),
        ("wasm-fpga-store", ["CHANGELOG.md", "AUTHORS", "LICENSE"]),
    ],
    setup_requires=[],
    install_requires=[],
    entry_points={},
)
