#= require ../pr_tool

class PullRequestIndexCtrl
  constructor: ($scope) ->
    $scope.pullRequests = [
      { id: 1, githubId: 123, repo: "thoughtbot/pr-tool", title: "Implement Stuff", tags: ["rails", "code"] }
      { id: 2, githubId: 124, repo: "thoughtbot/pr-tool", title: "Design Stuff", tags: ["design"] }
    ]

@app.controller("PullRequestIndexCtrl",
  ["$scope", PullRequestIndexCtrl])
