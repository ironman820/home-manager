{
  config,
  osConfig,
  ...
}: {
  imports = [
    "./homes/${config.user.name}@${osConfig.hostName}"
  ];
}
