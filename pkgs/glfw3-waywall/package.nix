{ glfw3-minecraft }:
glfw3-minecraft.overrideAttrs (old: {
  patches = old.patches ++ [ ./window-position.patch ];
})
