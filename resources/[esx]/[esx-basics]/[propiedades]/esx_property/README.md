# esx_property

### Requirements

- [async](https://github.com/ESX-Org/async)
- [instance](https://github.com/ESX-Org/instance)
- [cron](https://github.com/ESX-Org/cron)
- [esx_addonaccount](https://github.com/ESX-Org/esx_addonaccount)
- [esx_addoninventory](https://github.com/ESX-Org/esx_addoninventory)
- [esx_datastore](https://github.com/ESX-Org/esx_datastore)

## Download & Installation

### Using [fvm](https://github.com/qlaffont/fvm-installer)
```

### Manually
- Download https://github.com/1Skillers/esx_property/archive/1.0.0.zip
- Put it in the `[esx]` directory

## Installation
- Import `esx_property.sql` in your database
- Import `esx_offices.sql` in your database if you want offices (The Arcadius Business Centre is not included because realstateagentjob)
- Add this to your `server.cfg`:

```
start esx_property
```
