# ionic build bash script

bash script I wrote to help ionic/Angular run and build their app smoothly! This version only supports cordova.

## usage

```sh
bash build.sh {environment} {platform} {optional}:
```

- {environment} => the environment you target for build
- {ios or android} => which platform you target can be ios or android
- {optional} => this last argument is option one whither you want to run the app in real device or emulator

> Note: `prod` is production environment for this script you may need to change it if you using different name

## examples

```sh
bash build.sh prod ios
```

this will build the app for **production** environment and for **ios** platform

```sh
bash build.sh uat android run
```

this will run the app for **uat** environment and for **android** platform