defmodule PeusapatWeb.HelpersTest do
  use PeusapatWeb.ConnCase

  describe "Helpers" do
    test "remove_email/1" do
      assert PeusapatWeb.Live.Helpers.remove_email("test@test.com") == "test"
    end

    test "get_readable_date/1" do
      assert PeusapatWeb.Live.Helpers.get_readable_date(DateTime.utc_now()) =~
               ~r/\d{2} \w{3} \d{4}, \d{2}:\d{2}/
    end

    test "render_md/1" do
      assert PeusapatWeb.Live.Helpers.render_md("test") == "<p>\ntest</p>\n"
    end
  end
end
