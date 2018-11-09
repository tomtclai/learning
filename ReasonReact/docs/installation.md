---
title: Installation
---

**Note**: for general Reason + BuckleScript editor setup, see [here](https://reasonml.github.io/docs/en/editor-plugins).

## Bsb

```sh
npm install -g bs-platform
bsb -init my-react-app -theme react
cd my-react-app && npm install && npm start
# in another tab
npm run webpack
```

BuckleScript's [bsb](https://bucklescript.github.io/docs/en/build-overview.html) build system has an `init` command that generates a project template. The `react` theme offers a lightweight solution optimized for low learning overhead and ease of integration into an existing project.

It compiles to straightforward JS files, so you can open `index.html` directly from the file system. No server needed.
