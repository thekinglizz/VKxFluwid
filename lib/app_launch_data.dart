class AppLaunchData {
  final String parentOrigin;
  
  // Dev Settings
  AppLaunchData.dev() : parentOrigin = "http://localhost:9000";

  // Prod Settings
  // TODO - change to real prod origin
  AppLaunchData.prod() : parentOrigin = "http://example.com";
}

