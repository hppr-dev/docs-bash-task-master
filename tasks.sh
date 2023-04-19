arguments_serve() {
  SERVE_DESCRIPTION="Serve the mkdocs on port 8000"
}

task_serve() {
  mkdocs serve --dev-addr=0.0.0.0:8000
}
