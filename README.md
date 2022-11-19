[![GitHub Release][releases-shield]][releases]
![Project Stage][project-stage-shield]
[![License][license-shield]](LICENSE.md)

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports armv7 Architecture][armv7-shield]
![Supports i386 Architecture][i386-shield]

[![Github Actions][github-actions-shield]][github-actions]
![Project Maintenance][maintenance-shield]
[![GitHub Activity][commits-shield]][commits]

# kamstrup-40x-mqtt-hassio
This is a Docker wrapper around the github project of Matthijs Visser (https://github.com/matthijsvisser/kamstrup-402-mqtt) to make it available as https://home-assistant.io addon.

## Pre-requisite
Make sure you have a compatible IR-reader to be used with this add-on. Various can be used, known to work are:
- (*Tested Personally*): https://www.aliexpress.com/item/1005003509520122.html
- (*Tested by Pieter Brinkman*): https://shop.weidmann-elektronik.de/index.php?page=product&info=24
- 
## Installation
1. If you don't have a MQTT broker yet; in Home Assistant go to **Settings → Add-ons → Add-on store** and install the **Mosquitto broker** addon.
2. Go back to the **Add-on store**, click **⋮ → Repositories**, fill in</br>  `https://github.com/jrkalf/kamstrup-40x-mqtt-hassio` and click **Add → Close**.
3. The repository includes only one add-on.
4. Click on the addon and press **Install** and wait till the addon is installed.
5. Click on **Configuration**
   1. Get the Mosquitto broker addon ip-address, username and password.
   2. *Make sure the IR reader is already connected prior to configuration.* When done so, it should show up a IR reader device in your devices selection where you can select it.
6. Start the Add-on. If you don't have warnings in the log, you may assume it's working ;)
   *Error handling still needs to be improved...*

## Configuring Home Assistant
Now that the Add-on is running and the data should be uploaded every 28 minutes (default setting), it's time to setup Home Assistant to properly process the data.

Edit your `configuration.yaml` file to include this piece of code:
```yaml
mqtt:
  sensor:
    - name: "CH_Consumed_Energy"
      unique_id: ac9ea578-1bc3-4ac5-8ded-956837439c0a
      state_topic: "kamstrup/values"
      value_template: "{{ value_json.energy }}"
      unit_of_measurement: "GJ"
      device_class: "gas"
    - name: "CH_Consumed_Water"
      unique_id: b580bd91-18a7-43a3-8793-07c86601c5b5
      state_topic: "kamstrup/values"
      value_template: "{{ value_json.volume }}"
      unit_of_measurement: "m³"
    - name: "CH_Temperature_in"
      unique_id: c75cc7f8-46a7-4cb0-83ec-095a724aaa3b
      state_topic: "kamstrup/values"
      value_template: "{{ value_json.temp1 }}"
      unit_of_measurement: "°C"
    - name: "CH_Temperature_out"
      unique_id: 063567d4-2fda-4a97-9428-0943964ac353
      state_topic: "kamstrup/values"
      value_template: "{{ value_json.temp2 }}"
      unit_of_measurement: "°C"
    - name: "CH_Temperature_diff"
      unique_id: ca0ed78d-38cf-4499-bd10-54f6373a2fbf
      state_topic: "kamstrup/values"
      value_template: "{{ value_json.tempdiff }}"
      unit_of_measurement: "°C"
    - name: "CH_Current_flow"
      unique_id: efb11b38-81e9-4161-a25f-875be65c8c59
      state_topic: "kamstrup/values"
      value_template: "{{ value_json.flow }}"
      unit_of_measurement: "l/uur"
    - name: "CH_to_Gas"
      unique_id: ca4c30b5-7fd1-4b1e-9236-a64194418341
      state_topic: "kamstrup/values"
      # apply formula to value to translate to gas
      value_template: "{{ value_json.energy | float * 32 }}"
      unit_of_measurement: "m³"
      state_class: "total_increasing"
      device_class: "gas"  
```
*The unique_id: fields can be chosen by you. This is the proper way of making sure your sensors are truly unique. I chose to use a UUIDv4 generator to generate unique id's.*

This should provide you with enough sensors for you to read out all sensors and also use the CH_to_Gas as input for the Energy Dashboard.

# TO DO
This is still a work in progress. It currently works with the Kamstrup 403 device. It's known to work with Kamstrup 402 as well, but I still need to code the parity variables.

## Issues
If you find any issues with the add-on, please check the [issue tracker](https://github.com/jrkalf/kamstrup-40x-mqtt-hassio/issues) for similar issues before creating one.

Feel free to create a PR for fixes and enhancements. 

## External links that helped me build this Add-on and file
The actual python code that runs all the Kamstrup magic has been produced by Matthijs Visser. His github repo is being pulled by this addon and used for configuration:
- https://github.com/matthijsvisser/kamstrup-402-mqtt

Pieter Brinkman provided all necessary hints to configure Home Assistant to use the sensory data from the above script from Matthijs Visser:
- https://www.pieterbrinkman.com/2022/02/01/make-your-city-heating-stadsverwarming-smart-and-connect-it-home-assistant-energy-dashboard/
- 