# coding: utf-8
class Manage::StatisticsController < ApplicationController

  layout "manage"
  helper 'manage'

  before_filter :require_employee
  before_filter :set_action, :set_menu

  def index
    @title = 'Statistiky obchodu'
    @info = 'Měsíční statistiky zaznamenávají období posledních 30 dnů' 
    if flash[:success]
      @info = flash[:success]
    end

    @customer_count = Customer.count
    @employee_count = Employee.count
    @finished_orders_count = Order.count(:conditions => 'state = 2')
    @waiting_orders_count  = Order.count(:conditions => 'state = 1')
    @total_sum_orders = Order.sum(:sum)
    @finished_supplies_count = Supply.count(:conditions => 'state = 2')
    @waiting_supplies_count  = Supply.count(:conditions => 'state = 1')
    @total_sum_supplies = Supply.sum(:sum)    

    monthly_orders = Order.where(
      "(state = 1 OR state = 2) AND created_at > :last_month",
      { :last_month => Time.now.months_ago(1) } 
    )
    @m_finished_orders_count = monthly_orders.count(:conditions => 'state = 2')
    @m_waiting_orders_count  = monthly_orders.count(:conditions => 'state = 1')
    @m_total_sum_orders      = monthly_orders.sum(:sum)
      
  end

  def months
    @title = 'Celkové částky ~ měsíce'
    count = params[:count].to_i > 0 ? params[:count].to_i : 3
    actual = Date.parse("#{params[:y]||Date.today.year}-#{params[:m]}-01")
    @stats = {}
    count.times do
      orders = Order.finished_in_month actual
      @stats[actual] = {
        :count  => orders.count,
        :sum    => orders.sum(:sum),
        :orders => orders
      }        
      actual = actual.prev_month
    end
  end

  def month
    @title = 'Počty prodaných produktů v měsíci'
    y = params[:y]||Date.today.year
    m = params[:m]||Date.today.month
    @month = Date.parse("#{y}-#{m}-01")
    @products = Order.monthly_products @month
  end

private

  def set_menu
    @menu = [
    {:title=>'Celkem ~ tento měsíc', :href=>"/statistics/1/months/#{Date.today.month}/#{Date.today.year}",  :norel=>true},
    {:title=>'Celkem ~ minulý měsíc', :href=>"/statistics/1/months/#{Date.today.prev_month.month}/#{Date.today.prev_month.year}",  :norel=>true},
    {:title=>'Celkem ~ 3 měsíce', :href=>"/statistics/3/months/#{Date.today.month}/#{Date.today.year}",  :norel=>true},
    {:title=>'Produkty ~ tento měsíc', :href=>'/statistics/month', :norel=>true},
    {:title=>'Produkty ~ minulý měsíc', :href=>"/statistics/month/#{Date.today.prev_month.month}/#{Date.today.prev_month.year}", :norel=>true}
    ]
  end

  def set_action
    @action = 'statistics'
  end

end
