rule = {
  matches = {
    {
      { "node.name", "equals", "alsa_output.pci-0000_03_00.1.hdmi-stereo" },
    }
  },
  apply_properties = {
    ["device.disabled"] = true
  }
}

rule2 = {
  matches = {
    {
      { "device.name", "equals", "alsa_card.pci-0000_6e_00.6" },
    }
  },
  apply_properties = {
    ["device.disabled"] = true
  }
}

rule3 = {
  matches = {
    {
      { "device.name", "equals", "alsa_card.pci-0000_03_00.1" },
    }
  },
  apply_properties = {
    ["device.disabled"] = true
  }
}

table.insert(alsa_monitor.rules, rule)
-- table.insert(alsa_monitor.rules, rule2)
table.insert(alsa_monitor.rules, rule3)
