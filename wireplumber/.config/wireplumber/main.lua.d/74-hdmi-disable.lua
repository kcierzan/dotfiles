-- disable monitor audio
-- local disable_hdmi = {
--   matches = {
--     {
--       { "node.name", "equals", "alsa_output.pci-0000_03_00.1.hdmi-stereo" },
--     }
--   },
--   apply_properties = {
--     ["device.disabled"] = true
--   }
-- }


-- 1/4 inch headphone jack
local disable_headphones = {
  matches = {
    {
      { "device.name", "equals", "alsa_card.pci-0000_6e_00.6" },
    }
  },
  apply_properties = {
    ["device.disabled"] = true
  }
}

-- disable RME
local disable_usb = {
  matches = {
    {
      { "device.name", "equals", "alsa_card.usb-GeneralPlus_USB_Audio_Device-00" },
    }
  },
  apply_properties = {
    ["device.disabled"] = true
  }
}

-- disable HDMI
local disable_hdmi = {
  matches = {
    {
      { "device.name", "equals", "alsa_card.pci-0000_03_00.1" },
    }
  },
  apply_properties = {
    ["device.disabled"] = true
  }
}

-- table.insert(alsa_monitor.rules, disable_hdmi)
-- table.insert(alsa_monitor.rules, disable_headphones)
table.insert(alsa_monitor.rules, disable_hdmi)
table.insert(alsa_monitor.rules, disable_usb)
