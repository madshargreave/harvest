# defmodule Harvest.ServerWeb.JobControllerTest do
#   use Harvest.ServerWeb.ConnCase

#   @create_attrs %{
#     "user_id" => "1",
#     "query" => %{
#       "sources" => %{
#         "coinmarketcap" => %{
#           "type" => "crawler",
#           "concurrency" => 5,
#           "config" => %{
#             "url" => "https://coinmarketcap.com",
#             "container" => "table#currencies > tbody > tr",
#             "mapping" => [
#               %{
#                 "key" => "name",
#                 "transforms" => [
#                   %{"access" => "a.currency-name-container"},
#                   %{"lowercase" => true}
#                 ]
#               },
#               %{
#                 "key" => "symbol",
#                 "transforms" => [
#                   %{"access" => ".circulating-supply > span > span:last-child"},
#                   %{"lowercase" => true}
#                 ]
#               },
              # %{
              #   "key" => "marketcap",
              #   "transforms" => [
              #     %{"access" => ".market-cap"},
              #     %{"trim" => true},
              #     %{"regex" => "$([0-9\,]+)"},
              #     %{"replace" => [",", ""]},
              #     %{"cast" => "integer"}
              #   ]
              # },
#               %{
#                 "key" => "price",
#                 "transforms" => [
#                   %{"access" => ".price"},
#                   %{"trim" => true},
#                   %{"regex" => "$([0-9\,\.]+)"},
#                   %{"replace" => [",", ""]},
#                   %{"cast" => "float"}
#                 ]
#               }
#             ]
#           }
#         },
#         "sqs" => %{
#           "type" => "sqs",
#           "concurrency" => 10,
#           "timeout" => 5000,
#           "config" => %{
#             "access_key_id" => "AWS_ACCESS_KEY_ID",
#             "secret_access_key" => "AWS_SECRET_ACCESS_KEY"
#           }
#         }
#       },
#       "from" => %{
#         "name" => "coins",
#         "source" => "coinmarketcap"
#       },
#       "where" => [
#         %{
#           "field" => "marketcap",
#           "relation" => "greater_than",
#           "value" => 100_000_000
#         }
#       ],
#       "select" => %{
#         "name" => "coins.name",
#         "symbol" => "coins.symbol",
#         "marketcap" => "coins.marketcap",
#         "price" => "coins.price"
#       },
#       "into" => "sqs"
#     }
#   }

#   setup %{conn: conn} do
#     {:ok, conn: put_req_header(conn, "accept", "application/json")}
#   end

#   describe "list jobs" do
#     test "it renders a list of jobs", %{conn: conn} do
#       conn =
#         conn
#         |> post(job_path(conn, :create), job: @create_attrs)
#         |> post(job_path(conn, :create), job: @create_attrs)
#         |> get(job_path(conn, :index))

#       assert %{
#         "data" => [
#           %{
#             "id" => _,
#             "user_id" => "1",
#             "status" => "created"
#           },
#           %{
#             "id" => _,
#             "user_id" => "1",
#             "status" => "created"
#           }
#         ]
#       } = json_response(conn, 200)
#     end
#   end

#   describe "create job" do
#     test "renders job when data is valid", %{conn: conn} do
#       conn = post conn, job_path(conn, :create), job: @create_attrs
#       assert %{
#         "data" => %{
#           "id" => _,
#           "status" => "created"
#         }
#       } = json_response(conn, 201)
#     end
#   end

# end
