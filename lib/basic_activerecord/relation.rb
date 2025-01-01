class Relation
  attr_reader :where_values, :order_values

  def initialize(model)
    @model = model
    @where_values = []
    @order_values = []
  end

  def where(conditions)
    tap { @where_values << conditions }
  end

  def order(order)
    tap { @order_values << order }
  end
  
  def to_sql
    where_clause = @where_values.empty? ? '' : "WHERE " + @where_values.map { |cond| cond.map { |k, v| "#{k} = '#{v}'" }.join(' AND ') }.join(' AND ')
    order_clause = @order_values.empty? ? '' : "ORDER BY " + @order_values.map { |cond| cond.map { |k, v| "#{k} #{v}" }.join(', ') }.join(', ')

    [where_clause, order_clause].reject(&:empty?).join(' ')
  end
end