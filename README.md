# Ash-Slapshot

Ash-Slapshot is an [Ash](https://github.com/BrandonRomano/ash) module that automates the build + upload process for HockeyApp.

## Getting started

You're going to have to install [Ash](https://github.com/BrandonRomano/ash) to use this module, as it is tightly coupled to the Ash core.

After you have Ash installed, run either one of these two commands depending on your git clone preference:

- `ash self:install git@github.com:carrot/ash-slapshot.git`
- `ash self:install https://github.com/carrot/ash-slapshot.git`

You can also add the `--global` flag to install globally, or add this to your `Ashmodules` file depending on your preference.

## Setting up Ash-Slapshot with your application

### Android

Before we get started, you're going to have to have to obtain a HockeyApp API token.  You can create one at `https://rink.hockeyapp.net` in `Account Settings > API Tokens`.

The API token must be set with access to `All Apps` and also have `Full Access` rights if the application hasn't been created yet (This is a requirement of HockeyApp's API).  After you've made your first upload, you are free to create an API Token with access to only your app.

After we have our API token, we may in our application's base directory call:

```bash
ash slapshot:init
```

You'll note a `slapshot_config.yaml` file has been created in the current directory.  Update the `hockey_app_api_token` variable to match your token, and we're now all set up (It's possible you may need to tweak the other variables depending on your setup, but the defaults should match a majority of use cases).

To cut a build we can now in the applications base directory run:

```bash
ash slapshot:build
```

After you receive a message logging that you have a successful build, you can now run:

```bash
ash slapshot:upload
```

All subsequent builds will also be cut in the same manner.

### iOS

There is currently not support for iOS.  If there is any interest we can explore adding support for iOS.

## License

[MIT](license.txt)
