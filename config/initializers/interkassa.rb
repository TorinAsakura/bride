require 'psp/interkassa_acceptor'
ActionView::Base.send(:include, InterkassaAcceptor::ViewExtension)
ActionController::Base.send(:include, InterkassaAcceptor::ControllerExtension)