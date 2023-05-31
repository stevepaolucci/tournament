# frozen_string_literal: true

class EventReflex < ApplicationReflex
  def preview_event
    @event = Event.find(element.dataset[:id])
    morph '#offcanvas_content', render(View::Events::PreviewComponent.new(event: @event))
    # UserActivityLog.view(user: @user, resource: @lead)
    # title = "#{component('ui/icon', locals: { name: 'icon_nurse', use_assets_icons: true, classes: 'text-proton-300 float-left mt-0.5 mr-2' })} Preview Lead Details"
    # cable_ready.inner_html(selector: '#offcanvasRightLabel', html: title)
  end

  # move this
  def jazz_job_preview
    @jazz_job = JazzJob.where(job_id: element.dataset[:id]).first
    @jazz_req = JazzReq.where(job_id: element.dataset[:id]).first
    morph '#offcanvas_content', render(View::Leads::JazzJobComponent.new(jazz_job: @jazz_job, jazz_req: @jazz_req))
    title = "#{component('ui/icon', locals: { name: 'newspaper', use_assets_icons: false, classes: 'float-left mt-0.5 mr-2 text-proton-400' })} Job Description"
    cable_ready.inner_html(selector: '#offcanvasRightLabel', html: title)
  end

  def show_lead
    show_off_canvas
  end

  def add_note
    lead = Lead.find(params['lead_id'])
    user = User.find(params['user_id'])
    Current.user = user
    note = Note.create(noteable: lead, creator_id: params['user_id'], body: params['body'])
    params['lead']['tag_list']&.split('|')&.each do |tag|
      note.add_tag(tag)
    end
    lead.update(market_status: params['lead']['market_status'])

    notes = Note.where(noteable_type: 'Lead', noteable_id: params['lead_id'])
    morph '#notes', render(View::Leads::NoteComponent.new(notes:))
    # re render form
    cable_ready.inner_html(
      selector: '#create-note-form',
      html: render(partial: '/view/leads/create_note_form', locals: { lead:, user: })
    )
    lead.reload
    cable_ready.outer_html(
      selector: "#lead-row-#{lead.id}",
      html: render(partial: 'leads/lead_row', locals: { lead: })
    )
  end

  def show_notes
    @lead = Lead.find(element.dataset[:id])
    @user = User.find(element.dataset[:uid])
    morph '#offcanvas_content_email', render(View::Leads::NotesComponent.new(lead: @lead, user: @user))
    UserActivityLog.view(user: @user, resource: @lead)
    title = "#{component('ui/icon', locals: { name: 'icon_nurse', use_assets_icons: true, classes: 'text-proton-300 float-left -mt-0.5 mr-2' })} Create a Note"
    cable_ready.inner_html(selector: '#offcanvasEmailLabel', html: title)
  end

  def cta_text
    show_off_canvas
    cable_ready.remove_css_class(
      selector: '[id=lead-call-cta]',
      name: 'bg-tertiary'
    )
    cable_ready.add_css_class(
      selector: '[id=lead-call-cta]',
      name: 'bg-gold_fever-500'
    )
  end

  def cta_call
    show_off_canvas
    cable_ready.remove_css_class(
      selector: '[id=lead-call-cta]',
      name: 'bg-tertiary'
    )
    cable_ready.add_css_class(
      selector: '[id=lead-call-cta]',
      name: 'bg-gold_fever-500'
    )
  end

  def cta_email
    @lead = Lead.find(element.dataset[:id])
    @user = User.find(element.dataset[:uid])
    morph '#offcanvas_content_email', render(View::Leads::EmailComponent.new(lead: @lead, user: @user))
    UserActivityLog.view(user: @user, resource: @lead)
    title = "#{component('ui/icon', locals: { name: 'envelope', use_assets_icons: false, classes: 'text-proton-300 float-left -mt-0.5 mr-2' })} Email Lead"
    cable_ready.inner_html(selector: '#offcanvasEmailLabel', html: title)

    cable_ready.remove_css_class(
      selector: '[id=lead-email-cta]',
      name: 'bg-tertiary'
    )
    cable_ready.add_css_class(
      selector: '[id=lead-email-cta]',
      name: 'bg-gold_fever-500'
    )
  end

  def call_or_text
    lead = Lead.find(element.dataset[:id])
    user = User.find(element.dataset[:uid])

    update_modal(
      title: "Call or text #{lead.full_name}",
      content: render(View::Leads::CallOrTextComponent.new(lead:, user:))
    )
  end

  def log_call_or_text
    @lead = Lead.find(lead_params[:lead_id])
    @user = User.find(lead_params[:user_id])

    if params[:commit] == 'Texted' # reflex isn't sending correct params
      UserActivityLog.text(user: @user, resource: @lead)
    else
      UserActivityLog.phone(user: @user, resource: @lead)
    end
  end

  def flag_email
    lead = Lead.find(element.dataset[:id])
    user = User.find(element.dataset[:uid])

    lead.flag_email(user:)

    morph '#flag-email', render(partial: 'leads/flag_email', locals: { lead:, user: })
    morph "#red_flag_#{lead.id}", render(partial: 'leads/flag_icon', locals: { lead:, user: })
  end

  def unflag_email
    lead = Lead.find(element.dataset[:id])
    user = User.find(element.dataset[:uid])

    lead.unflag_email

    morph '#flag-email', render(partial: 'leads/flag_email', locals: { lead:, user: })
    morph "#red_flag_#{lead.id}", render(partial: 'leads/flag_icon', locals: { lead:, user: })
  end

  def flag_phone
    lead = Lead.find(element.dataset[:id])
    user = User.find(element.dataset[:uid])

    lead.flag_phone(user:)

    morph '#flag-phone', render(partial: 'leads/flag_phone', locals: { lead:, user: })
    morph "#red_flag_#{lead.id}", render(partial: 'leads/flag_icon', locals: { lead:, user: })
  end

  def unflag_phone
    lead = Lead.find(element.dataset[:id])
    user = User.find(element.dataset[:uid])

    lead.unflag_phone

    morph '#flag-phone', render(partial: 'leads/flag_phone', locals: { lead:, user: })
    morph "#red_flag_#{lead.id}", render(partial: 'leads/flag_icon', locals: { lead:, user: })
  end

  def edit_flags
    lead = Lead.find(element.dataset[:id])
    user = User.find(element.dataset[:uid])

    update_modal(
      title: "Edit Flags for #{lead.full_name}",
      content: render(View::Leads::EditFlagsComponent.new(lead:, user:))
    )
  end

  def update_flags
    lead = Lead.find(lead_params[:lead_id])
    user = User.find(lead_params[:user_id])
    if lead_params[:red_flagged] == '1' && lead_params[:red_flagged_reason].blank?
      update_modal(
        error_msg: 'Please enter a reason for the red flag',
        title: "Create Red Flag for #{lead.full_name}",
        content: render(View::Leads::EditFlagsComponent.new(lead:, user:))
      )
    else
      if lead_params[:red_flagged] == '1' && lead_params[:red_flagged_reason] != lead.red_flagged_reason # rubocop:disable Style/IfUnlessModifier
        lead.red_flag(user:, reason: lead_params[:red_flagged_reason])
      end
      lead.remove_red_flag if lead_params[:red_flagged] == '0' && lead.red_flagged?
      lead.flag_email(user:) if lead_params[:bad_email_flag] == '1' && !lead.bad_email_flag?
      lead.unflag_email      if lead_params[:bad_email_flag] == '0' && lead.bad_email_flag?
      lead.flag_phone(user:) if lead_params[:bad_phone_flag] == '1' && !lead.bad_phone_flag?
      lead.unflag_phone      if lead_params[:bad_phone_flag] == '0' && lead.bad_phone_flag?
    end
  end

  def edit_market_status
    lead = Lead.find(element.dataset[:id])
    user = User.find(element.dataset[:uid])

    update_modal(
      title: "Edit Market Status for #{lead.full_name}",
      content: render(View::Leads::MarketComponent.new(lead:, user:))
    )
  end

  def update_market_status
    lead = Lead.find(lead_params[:lead_id])
    lead.update(market_status: lead_params[:market_status])
  end

  private

  def lead_params
    params.require(:lead).permit(:user_id, :lead_id, :market_status, :bad_email_flag, :bad_phone_flag, :red_flagged, :red_flagged_reason)
  end

  def show_off_canvas
    @lead = Lead.find(element.dataset[:id])
    @user = User.find(element.dataset[:uid])
    morph '#offcanvas_content', render(View::Leads::ShowComponent.new(lead: @lead, user: @user))
    UserActivityLog.view(user: @user, resource: @lead)
  end
end
