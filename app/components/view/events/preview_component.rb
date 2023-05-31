# frozen_string_literal: true

module View
    module Events
      class PreviewComponent < ViewComponent::Base
        def initialize(event:)
          @event = event
        end
      end
    end
  end
  