# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Biomodis::Application.initialize!

# ********* FRANK CODE **************.
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
# ********* END FRANK CODE **************.
