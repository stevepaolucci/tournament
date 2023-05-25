# frozen_string_literal: true

class MyOpenJobsReflex < ApplicationReflex
  def getjob
    j = Job.find(element.dataset[:id])
    morph '#offcanvas_content', render(View::Jobs::Show::ShowComponent.new(job: j, title: j.title))
  end

  def getjobdescription
    j = JobDescription.find(element.dataset[:id])
    morph '#offcanvas_content', render(View::JobDescriptions::Show::ShowComponent.new(job_description: j, title: j.title))
  end

  def getperson
    p = Person.find(element.dataset[:id])
    morph '#offcanvas_content', render(View::MyOpenJobs::PersonComponent.new(person: p))
  end

  def getapplication
    a = Application.find(element.dataset[:id])
    morph '#offcanvas_content', render(View::MyOpenJobs::ApplicationComponent.new(application: a))
  end

  def send_email
    LeadMailer.contact(params['user_id'], params['lead_id'], params['body'], params['subject']).deliver_now
    morph '#email_status', 'Email Sent'
  end

  def favorite
    lead_id = element.dataset[:id]
    user_id = element.dataset[:uid]
    favorites = Favorite.where(favorited_type: 'Lead', favorited_id: lead_id, user_id:)
    if favorites.present?
      favorites.destroy_all
      morph "#favorite_#{element.dataset[:id]}", component('ui/icon', locals: { name: :heart, variant: :mini, size: :xsm, classes: 'text-gray-200' })
    else
      Favorite.create(favorited_type: 'Lead', favorited_id: lead_id, user_id:, active: true)
      morph "#favorite_#{element.dataset[:id]}", component('ui/icon', locals: { name: :heart, variant: :mini, size: :xsm, classes: 'text-proton-300' })
    end
  end

  def load_parsed_description(jd_text)
    morph '#description_text', render(View::JobDescriptions::New::DescriptionTextComponent.new(text: jd_text, level: 'basic', color: 'gray'))
  end

  def schedule
    a = Application.find(element.dataset[:id])
    morph '#offcanvas_content', render(View::MyOpenJobs::ScheduleComponent.new(application: a))
  end

  def getapplications
    j = Job.find(element.dataset[:id])
    # a = Application.where(job_id: element.dataset[:id])
    morph '#job_applicants', render(View::MyOpenJobs::ApplicationListComponent.new(collection: j))
  end
end
