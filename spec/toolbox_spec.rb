require "spec_helper"

RSpec.describe Runbook::Toolbox do
  let(:prompt) { instance_double("TTY::Prompt") }
  let(:toolbox) { Runbook::Toolbox.new }
  let(:msg) { "Something I want to say" }
  let(:default) { "default" }
  let(:choices) { [
    { key: "y", name: "Yes", value: true },
  ] }

  before(:each) do
    allow(TTY::Prompt).to receive(:new).and_return(prompt)
  end

  describe "initialize" do
    it "assigns a TTY::Prompt to prompt" do
      expect(toolbox.prompt).to eq(prompt)
    end
  end

  describe "ask" do
    it "passes its argument to prompt.ask" do
      expect(prompt).to receive(:ask).with(msg, default: nil, echo: true)
      toolbox.ask(msg)
    end

    it "passes its default to prompt.ask" do
      expect(prompt).to receive(:ask).with(msg, default: default, echo: true)
      toolbox.ask(msg, default: default)
    end

    it "passes its echo to prompt.ask" do
      expect(prompt).to receive(:ask).with(msg, default: nil, echo: false)
      toolbox.ask(msg, echo: false)
    end
  end

  describe "expand" do
    it "passes its argument to prompt.ask" do
      expect(prompt).to receive(:expand).with(msg, choices)
      toolbox.expand(msg, choices)
    end
  end

  describe "yes?" do
    it "passes its argument to prompt.yes?" do
      expect(prompt).to receive(:yes?).with(msg)
      toolbox.yes?(msg)
    end

    it "re-prompts when receiving unknown input" do
      msg = "Unknown input: Please type 'y' or 'n'."
      expect(prompt).to receive(:yes?).with(msg) do
        raise TTY::Prompt::ConversionError
      end
      expect(prompt).to receive(:yes?)
      expect(prompt).to receive(:warn).with(msg)

      toolbox.yes?(msg)
    end
  end

  describe "output" do
    it "passes its argument to prompt.say" do
      expect(prompt).to receive(:say).with(msg)
      toolbox.output(msg)
    end
  end

  describe "warn" do
    it "passes its argument to prompt.warn" do
      expect(prompt).to receive(:warn).with(msg)
      toolbox.warn(msg)
    end
  end

  describe "error" do
    it "passes its argument to prompt.error" do
      expect(prompt).to receive(:error).with(msg)
      toolbox.error(msg)
    end
  end
end
