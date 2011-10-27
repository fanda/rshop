ActiveAdmin::Dashboards.build do


  section "Waiting orders" do
    table_for Order.waiting do |t|
      t.column("Status") { |order| status_tag (order.state_in_words), :error }
      t.column("Date") { |order| order.created_at.to_date }
      t.column("Customer") { |order|
        link_to order.customer.full_name, admin_customer_path(order.customer)
      }
      t.column("Suma") { |order| order.sum }
      t.column("Detail") { |order|
        link_to 'View', admin_order_path(order)
      }
    end
  end


  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.

  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end

  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end

  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.

end
