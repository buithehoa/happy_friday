<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Thanks again! Now go create something AMAZING! :D
***
***
***
*** To avoid retyping too much info. Do a search and replace for the following:
*** github_username, repo_name, twitter_handle, email, project_title, project_description
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![main Actions Status](https://github.com/buithehoa/happy_friday/workflows/Ruby/badge.svg)](https://github.com/buithehoa/happy_friday/actions)&nbsp;
[![Coverage](https://buithehoa.github.io/happy_friday/badge.svg)](https://github.com/buithehoa/happy_friday)

<!-- PROJECT LOGO -->
<p align="center">
  <h3 align="center">Happy Friday</h3>

  <p align="center">
    Build an optimal schedule for a distributed development team for this Friday.
    <br />
  </p>
</p>

<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#testing">Testing</a></li>
    <li><a href="#code-navigation">Code Nagivation</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

[Happy Friday Project Requirements](https://gist.github.com/tuykin/1671929728622749680def59d90910c7)

### Built With

The algorithm for scheduling job is primarily based on Branch and Bound algorithm which is addressed in this [Job Assignment Problem Using Branch and Bound](https://www.geeksforgeeks.org/job-assignment-problem-using-branch-and-bound/
) article.

<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

[Ruby 2.7](https://www.ruby-lang.org/en/downloads/)
<br/>
[Bundler 2.2](https://bundler.io/)

### Installation

1. Clone the repo
   ```sh
   git clone git@github.com:buithehoa/happy_friday.git
   ```
2. Install dependencies
   ```sh
   bundle install
   ```

<!-- USAGE EXAMPLES -->
## Usage

From the root folder of the project, execute `./bin/schedule` with parameters as follows
```sh
./bin/schedule <performance_csv_path> <tasks_csv_path> <teams_csv_path> <output_path>
```
Here's an example using existing CSV files included in the project. When option `-v` is provided, the content of the exported CSV will be printed out.
```sh
./bin/schedule -v ./spec/fixtures/files/sample_input/performance.csv spec/fixtures/files/sample_input/tasks.csv spec/fixtures/files/sample_input/teams.csv /tmp
```
The output will be similar to the following
```
+--------+-----------------------------+-----------------------------+---------+
| Team   | Local Time                  | UTC Time                    | Task No |
| Moscow | Fri 09:00 AM - Fri 01:00 PM | Fri 06:00 AM - Fri 10:00 AM | 1       |
| Moscow | Fri 01:00 PM - Fri 07:00 PM | Fri 10:00 AM - Fri 04:00 PM | 4       |
| London | Fri 09:00 AM - Fri 02:00 PM | Fri 09:00 AM - Fri 02:00 PM | 2       |
| London | Fri 02:00 PM - Fri 06:00 PM | Fri 02:00 PM - Fri 06:00 PM | 3       |
+--------+-----------------------------+-----------------------------+---------+
Exported file path: /tmp/schedule-20210915-104856.csv
```
The content of `/tmp/schedule-20210915-104856.csv` will be as follows
```
Team,Local Time,UTC Time,Task No
Moscow,09:00 AM - 01:00 PM,06:00 AM - 10:00 AM,1
Moscow,10:00 AM - 04:00 PM,10:00 AM - 04:00 PM,4
London,09:00 AM - 02:00 PM,09:00 AM - 02:00 PM,2
London,02:00 PM - 06:00 PM,02:00 PM - 06:00 PM,3
```

## Testing
To run all specs, execute `rspec`
```
$ bundle exec rspec
Finished in 1.13 seconds (files took 0.14603 seconds to load)
24 examples, 0 failures
```

## Code Navigation
1. The entry point of the program is `Main#run` which is called in `bin/schedule` as follows
  ```ruby
  Main.new(*ARGV).run
  ```
2. The scheduling algorithm is implemented in `Scheduler::BranchAndBound` and 2 supporting models: `Scheduler::Node` and `Scheduler::Workload` which can be found under `lib/scheduler`. The algorithm is triggered as follows in `Main`
  ```ruby
  schedule = Scheduler::BranchAndBound.new(
    workload.estimated_effort,
    workload.timezone_offsets).run
  ```
3. The functionality of `CSVHandler` class includes
  * Read input CSV files to collect input data
  * Export calculated schedule to CSV files

<!-- CONTACT -->
## Contact

Bui The Hoa - [@buithehoa](https://twitter.com/buithehoa)

Project Link: [https://github.com/buithehoa/happy_friday](https://github.com/buithehoa/happy_friday)


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[license-url]: https://github.com/github_username/repo_name/blob/master/LICENSE.txt
