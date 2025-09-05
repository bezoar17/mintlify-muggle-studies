# mintlify-muggle-studies
Solved Problems of leetcode, for reference

Steps To Update the Gitbook leetcode section.
1. Run the index js to fetch leetcode submissions along with other metadata
2. Copy the file to this repo, and run `ruby generator.rb` command to update the mintlify
3. Copy list of problems from PROBLEM_SUMMARY.md and update it in docs.json under leetcode-problems file in mintlify
4. Append the TOPIC_SECTIONS.md into docs.json under mintlify folder


TODO
+ Update script to prepare it for mintlify docs
+ Add scripts to get list info and update it correctly in mintlify docs.json

The following repo has an index.js file which builds a json file that is used as data to build the solution pages in gitbook.
Follow the steps mentioned in the repo's readme, the index.js script has been updated to be consumed for this gitbook task,
Hence has multiple changes from the original repository it was derived from.
https://github.com/bezoar17/fetch-leetcode-submission


Reference links

https://rahulravindran0108.gitbooks.io/leetcode-gitbook/content/

https://wentao-shao.gitbook.io/leetcode

https://just4once.gitbooks.io/leetcode-notes/content/

https://gitbook.sshiling.com/flg-preparation/algorithms/dynamic-programming/tasks

https://labuladong.gitbook.io/algo-en/iii.-algorithmic-thinking/detailsaboutbacktracking
