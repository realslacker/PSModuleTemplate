# initialize the configuration
Initialize-Config

# cleanup
$ExecutionContext.SessionState.Module.OnRemove = {}
