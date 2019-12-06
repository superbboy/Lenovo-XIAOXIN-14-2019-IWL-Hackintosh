// TPxx is my new's device
DefinitionBlock("", "SSDT", 2, "hack", "I2C-I2CX", 0)
{
    External(_SB.PCI0.I2C0, DeviceObj)
    External (_SB_.PCI0.I2C1, DeviceObj)
    
    External(TPDD, FieldUnitObj)
    External(TPDF, FieldUnitObj)
    External (FMD0, FieldUnitObj)
    External (FMD1, FieldUnitObj)
    External (FMH0, FieldUnitObj)
    External (FMH1, FieldUnitObj) 
    External (FML0, FieldUnitObj)
    External (FML1, FieldUnitObj)
    External (PKG3, MethodObj)    // 3 Arguments
    External (SSD0, FieldUnitObj)
    External (SSD1, FieldUnitObj)
    External (SSH0, FieldUnitObj)
    External (SSH1, FieldUnitObj)
    External (SSL0, FieldUnitObj)
    External (SSL1, FieldUnitObj)    
    
    // disable original I2C0.TPAD in macOS
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            TPDD = 3
        }
    }
    
    Method (PKGX, 3, Serialized)
    {
        Name (PKG, Package (0x03)
        {
            Zero, 
            Zero, 
            Zero
        })
        PKG [Zero] = Arg0
        PKG [One] = Arg1
        PKG [0x02] = Arg2
        Return (PKG) /* \PKGX.PKG_ */
    }    
    
    //path:_SB.PCI0.I2C0.TPAD
    Scope (_SB.PCI0.I2C0)
    {   
        // add conf         
        Method (SSCN, 0, NotSerialized)
        {
            Return (PKGX (SSH0, SSL0, SSD0))
        }

        Method (FMCN, 0, NotSerialized)
        {
            Return (PKGX (FMH0, FML0, FMD0))
        }
        
        // new device
                
        Device (TPXX)
        {
            Name (_ADR, One)  // _ADR: Address
            Name (_UID, One)  // _UID: Unique ID
            Name (_S0W, 0x03)  // _S0W: S0 Device Wake State
            Name (HID2, Zero)
            Name (TPID, Package (0x02)
            {
                Package (0x05)
                {
                    0x04, 
                    0x2C, 
                    0x20, 
                    "MSFT0001", 
                    "PNP0C50"
                }, 

                Package (0x05)
                {
                    0x08, 
                    0x15, 
                    One, 	
                    "MSFT0001", 
                    "PNP0C50"
                }
            })
            Name (SBFB, ResourceTemplate ()
            {
                I2cSerialBusV2 (0x0000, ControllerInitiated, 0x00061A80,
                    AddressingMode7Bit, "\\_SB.PCI0.I2C0",
                    0x00, ResourceConsumer, _Y43, Exclusive,
                    )
            })	
            Name (SBFG, ResourceTemplate ()
            {
                GpioInt (Level, ActiveLow, Exclusive, PullUp, 0x0000,
                    "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list, original 0x0038 cannot work
                        0x0108
                    }
            })
            CreateWordField (SBFB, \_SB.PCI0.I2C0.TPXX._Y43._ADR, ADR0)  // _ADR: Address
            Method (_HID, 0, Serialized)  // _HID: Hardware ID
            {
                If (Not (CondRefOf (TPDF)))
                {
                    Name (TPDF, 0xFE)
                }

                Switch (One)
                {
                    Case (Zero)
                    {
                        Store (0xFE, TPDF)
                    }
                    Case (One)
                    {
                    }
                    Default
                    {
                        Store (0xFE, TPDF)
                    }

                }

                Return (TPDS (0x03, 0xFE, "MSFT0001"))
            }

            Method (_CID, 0, Serialized)  // _CID: Compatible ID
            {
                If (Not (CondRefOf (TPDF)))
                {
                    Name (TPDF, 0xFE)
                }

                Switch (One)
                {
                    Case (Zero)
                    {
                        Store (0xFE, TPDF)
                    }
                    Case (One)
                    {
                    }
                    Default
                    {
                        Store (0xFE, TPDF)
                    }

                }

                Return (TPDS (0x04, 0xFE, "PNP0C50"))
            }

            Method (TPDS, 3, NotSerialized)
            {
                Store (Zero, Local0)
                Store (Zero, Local1)
                Store (DerefOf (Index (DerefOf (Index (TPID, Local0)), Zero)), Local1)
                While (LAnd (LNotEqual (Local1, Arg1), LNotEqual (Local1, TPDF)))
                {
                    Increment (Local0)
                    If (LGreaterEqual (Local0, SizeOf (TPID)))
                    {
                        Return (Arg2)
                    }

                    Store (DerefOf (Index (DerefOf (Index (TPID, Local0)), Zero)), Local1)
                }

                Return (DerefOf (Index (DerefOf (Index (TPID, Local0)), Arg0)))
            }

            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If (LEqual (Arg0, ToUUID ("3cdff6f7-4267-4555-ad05-b30a3d8938de") /* HID I2C Device */))
                {
                    If (LEqual (Arg2, Zero))
                    {
                        If (LEqual (Arg1, One))
                        {
                            Return (Buffer (One)
                            {
                                    0x03                                           
                            })
                        }
                        Else
                        {
                            Return (Buffer (One)
                            {
                                    0x00                                           
                            })
                        }
                    }

                    If (LEqual (Arg2, One))
                    {
                        Return (HID2)
                    }
                }
                Else
                {
                    Return (Buffer (One)
                    {
                            0x00                                           
                    })
                }

                If (LEqual (Arg0, ToUUID ("ef87eb82-f951-46da-84ec-14871ac6f84b")))
                {
                    If (LEqual (Arg2, Zero))
                    {
                        If (LEqual (Arg1, One))
                        {
                            Return (Buffer (One)
                            {
                                    0x03                                           
                            })
                        }
                        Else
                        {
                            Return (Buffer (One)
                            {
                                    0x00                                           
                            })
                        }
                    }

                    If (LEqual (Arg2, One))
                    {
                        Return (ConcatenateResTemplate (SBFB, SBFG))
                    }
                }
                Else
                {
                    Return (Buffer (One)
                    {
                            0x00                                           
                    })
                }

                Return (Buffer (One)
                {
                        0x00                                           
                })
            }

            Method (_STA, 0, Serialized)  // _STA: Status
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }

            Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
            {
                Store (Zero, Local0)
                Store (Zero, Local1)
                Store (DerefOf (Index (DerefOf (Index (TPID, Local0)), Zero)), Local1)
                While (LAnd (LNotEqual (Local1, 0xFE), LNotEqual (Local1, TPDF)))
                {
                    Increment (Local0)
                    If (LGreaterEqual (Local0, SizeOf (TPID)))
                    {
                        Break
                    }

                    Store (DerefOf (Index (DerefOf (Index (TPID, Local0)), Zero)), Local1)
                }

                Store (DerefOf (Index (DerefOf (Index (TPID, Local0)), One)), ADR0)
                Store (DerefOf (Index (DerefOf (Index (TPID, Local0)), 0x02)), HID2)

                Return (ConcatenateResTemplate (SBFB, SBFG))
            }
        }
    }

    // must add I2C0/I2C1 otherwise error
    Scope (_SB.PCI0.I2C1)
    {
        Method (SSCN, 0, NotSerialized)
        {
            Return (PKGX (SSH1, SSL1, SSD1))
        }

        Method (FMCN, 0, NotSerialized)
        {
            Return (PKGX (FMH1, FML1, FMD1))
        }
    }
}
//EOF
