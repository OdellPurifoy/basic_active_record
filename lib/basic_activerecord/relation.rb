class Relation
  attr_reader :where_values, :order_values, :not_values

  def initialize(model)
    @model = model
    @where_values = []
    @order_values = []
    @not_values = []
  end

  def where(conditions)
    tap { @where_values << conditions }
  end

  def order(order)
    tap { @order_values << order }
  end

  def where_not(conditions)
    tap { @not_values << conditions }
  end
  
  def to_sql
    where_clause = @where_values.empty? ? '' : "WHERE " + @where_values.map { |cond| cond.map { |k, v| "#{k} = '#{v}'" }.join(' AND ') }.join(' AND ')
    order_clause = @order_values.empty? ? '' : "ORDER BY " + @order_values.map { |cond| cond.map { |k, v| "#{k} #{v}" }.join(', ') }.join(', ')
    not_clause = @not_values.empty? ? '' : "WHERE " + @not_values.map { |cond| cond.map { |k, v| "#{k} <> '#{v}'" }.join(' AND ') }.join(' AND ')

    if not_clause.empty?
      [where_clause, order_clause].reject(&:empty?).join(' ')
    else
      not_clause
    end      
  end
end