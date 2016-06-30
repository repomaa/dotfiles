class QuickfixFormatter
  RSpec::Core::Formatters.register self, :example_failed

  def initialize(output)
    @output = output
  end

  def example_failed(notification)
    @output << format(notification) + "\n"
  end

  private

  def format(notification)
    result = Kernel.format(
      '%s: %s',
      notification.example.location,
      notification.exception.message
    )
    result.tr("\n", ' ')[0, 160]
  end
end
