class AppLaunchData {
  final String parentOrigin;
  
  // Dev Settings
  AppLaunchData.dev() : parentOrigin = "http://localhost:9000";

  // Prod Settings
  AppLaunchData.prod() : parentOrigin = "http://localhost:9000";
}

