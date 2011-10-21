class CustomerSession < Authlogic::Session::Base
    # configuration here, see documentation for sub modules of Authlogic::Session
    authenticate_with Customer
end
