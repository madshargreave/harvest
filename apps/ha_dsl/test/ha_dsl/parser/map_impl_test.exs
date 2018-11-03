defmodule HaDSL.Parser.MapImplTest do
  use ExUnit.Case
  import Exd.Query.Builder
  alias HaDSL.Parser.MapImpl, as: MapParser

  def valid_query(_context) do
    [
      params: %{
        steps: [
          %{
            from: %{
              type: "fetch",
              args: ["https://coinmarketcap.com"]
            }
          },
          %{
            map: %{
              row: [
                %{
                  type: "field",
                  args: ["body"],
                },
                %{
                  type: "html_parse_list",
                  args: [".list"]
                }
              ]
            }
          },
          %{
            unnest: :row
          },
          %{
            map: %{
              name: [
                %{
                  type: "field",
                  args: ["row"]
                },
                %{
                  type: "html_parse_text",
                  args: [".coin-name"]
                }
              ],
              symbol: [
                %{
                  type: "field",
                  args: ["row"]
                },
                %{
                  type: "html_parse_text",
                  args: [".coin-symbol"]
                }
              ],
              price: [
                %{
                  type: "field",
                  args: ["row"]
                },
                %{
                  type: "html_parse_text",
                  args: [".coin-price"]
                }
              ]
            }
          },
          %{
            filter: %{
              match: "all",
              conditions: [
                %{
                  field: :price,
                  relation: :greater_than,
                  value: 1000
                }
              ]
            }
          },
          # merge: %{
          #   website: [
          #     %{
          #       type: "fetch",
          #       args: ["https://coinmarketcap.com/currencies/?", "symbol"]
          #     },
          #     %{
          #       type: "field",
          #       args: ["body"],
          #     },
          #     %{
          #       type: "html_parse_text",
          #       args: [".website"]
          #     }
          #   ]
          # }
        ]
      }
    ]
  end

  # describe "when from is valid" do
  #   setup [:valid_query]

  #   test "it works", context do
  #     assert {:ok, result} = MapParser.parse(context.params.steps)
  #     assert result.from == (from r in fetch("https://coinmarketcap.com")).from
  #   end
  # end

  describe "when select is valid" do
    setup [:valid_query]

    test "it works", context do
      assert {:ok, result} = MapParser.parse(context.params.steps)
      assert result ==
        from r in subquery(
          from r in fetch("https://coinmarketcap.com"),
          select: %{
            row: unnest(html_parse_list(r.body, ".list"))
          }
        ),
        where: r.price > 1000,
        select: %{
          name: html_parse_text(r.row, ".coin-name"),
          symbol: html_parse_text(r.row, ".coin-symbol"),
          price: html_parse_text(r.row, ".coin-price")
        }
    end
  end

end
