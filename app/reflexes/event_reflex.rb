# frozen_string_literal: true

class EventReflex < ApplicationReflex
  def preview_event
    @event = Event.find(element.dataset[:id])
    morph '#offcanvas_content', render(View::Events::PreviewComponent.new(event: @event))
    # UserActivityLog.view(user: @user, resource: @lead)
    # title = "#{component('ui/icon', locals: { name: 'icon_nurse', use_assets_icons: true, classes: 'text-proton-300 float-left mt-0.5 mr-2' })} Preview Lead Details"
    # cable_ready.inner_html(selector: '#offcanvasRightLabel', html: title)
  end

  def create
    #prevent_refresh!
    @event = Event.new(event_params)
    morph '#status_div', 'event created' if @event.save

  end

  private

  def event_params
    params.require(:event).permit(:name, :level, :starts_at)
  end

end
