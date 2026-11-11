# Forgefolio — Unraid distribution

The public home for Forgefolio's Unraid packaging: the canonical manual
user-template, the app icon, and the maintainer profile for Community
Applications. The application source lives in the
[main repository](https://github.com/3rdof5/Forgefolio); the container image
is published at `ghcr.io/3rdof5/forgefolio`.

## Install on Unraid

```sh
curl -o /boot/config/plugins/dockerMan/templates-user/my-forgefolio.xml \
  https://raw.githubusercontent.com/3rdof5/forgefolio-unraid/main/templates/my-forgefolio.xml
```

Then **Docker → Add Container**, pick the `my-forgefolio` template, and follow
the [deployment guide](https://github.com/3rdof5/Forgefolio/blob/main/docs/DEPLOYMENT.md)
(appdata + models-library paths, PUID/PGID, first-admin creation, and the
update-persistence notes).

## Sync flow

When the template changes in the main repository, copy
`templates/my-forgefolio.xml` and `assets/icon.png` here and commit — the
raw URLs in the template's `TemplateURL`/`Icon`/`License` fields point at
this repository, so it is the one Community Applications and dockerMan see.

## License

[MIT](LICENSE) — Copyright (c) 2026 3rdof5.
