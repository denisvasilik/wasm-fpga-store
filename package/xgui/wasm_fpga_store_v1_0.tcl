# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"

  ipgui::add_param $IPINST -name "PinMaxAddress"
  ipgui::add_param $IPINST -name "MaxAddress"

}

proc update_PARAM_VALUE.MaxAddress { PARAM_VALUE.MaxAddress } {
	# Procedure called to update MaxAddress when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MaxAddress { PARAM_VALUE.MaxAddress } {
	# Procedure called to validate MaxAddress
	return true
}

proc update_PARAM_VALUE.PinMaxAddress { PARAM_VALUE.PinMaxAddress } {
	# Procedure called to update PinMaxAddress when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PinMaxAddress { PARAM_VALUE.PinMaxAddress } {
	# Procedure called to validate PinMaxAddress
	return true
}


proc update_MODELPARAM_VALUE.PinMaxAddress { MODELPARAM_VALUE.PinMaxAddress PARAM_VALUE.PinMaxAddress } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PinMaxAddress}] ${MODELPARAM_VALUE.PinMaxAddress}
}

proc update_MODELPARAM_VALUE.MaxAddress { MODELPARAM_VALUE.MaxAddress PARAM_VALUE.MaxAddress } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MaxAddress}] ${MODELPARAM_VALUE.MaxAddress}
}

