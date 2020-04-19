class HomeController < ApplicationController
  def index
    @result = search(search_params[:search], search_params[:page] || "1")
  end

  private

  def search(term, page)
    return response_object(true, "", apply_pagination(page, [])) if term.blank?

    begin
      items = []
      github.search.repositories(q: term).each_page do |page|
        page.items.each do |repo|
          items << (build_data_response repo)
        end
      end

      paginated_items = apply_pagination(page.to_i, items)
      response_object(true, "", paginated_items)
    rescue => e
      response_object(false, e.message)
    end
  end

  def response_object(success, msg, data = [])
    OpenStruct.new(success: success,
                   items: data,
                   error_msg: msg)
  end

  def build_data_response(repo)
    OpenStruct.new(
      full_name: repo.full_name,
      language: repo.language,
      url: repo.html_url,
      pushed_at: repo.pushed_at.blank? ? "" : repo.pushed_at.to_s.to_date.strftime("%-d %b %Y"),
    )
  end

  # pagination for non active record collections
  def apply_pagination(current_page, items)
    WillPaginate::Collection.create(current_page || 1, per_page, items.size) do |pager|
      unless items.empty?
        start = (current_page - 1) * per_page # assuming current_page is 1 based.
        pager.replace(items[start, per_page])
      end
    end
  end

  # secrets should not be here
  def github
    @github ||= Github.new client_id: "625cacc10fce2ecfd5ad",
                           client_secret: "d8a268c234d654576a65318b520e84324da6cb31"
  end

  def search_params
    params.permit(:search, :page)
  end

  def per_page
    @per_page ||= 30
  end
end
