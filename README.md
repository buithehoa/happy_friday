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
[![MIT License][license-shield]][license-url]

<!-- PROJECT LOGO -->
<br />
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
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
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
Here's an example using existing CSV files included with the project
```sh
./bin/schedule ./spec/fixtures/files/sample_input/performance.csv spec/fixtures/files/sample_input/tasks.csv spec/fixtures/files/sample_input/teams.csv /tmp
```
The output will be similar to the following
```
Processing step count: 537
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

## Code Nagivation

<!-- CONTACT -->
## Contact

Bui The Hoa - [@buithehoa](https://twitter.com/twitter_handle)

Project Link: [https://github.com/buithehoa/happy_friday](https://github.com/buithehoa/happy_friday)


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/github_username/repo.svg?style=for-the-badge
[contributors-url]: https://github.com/github_username/repo_name/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/github_username/repo.svg?style=for-the-badge
[forks-url]: https://github.com/github_username/repo_name/network/members
[stars-shield]: https://img.shields.io/github/stars/github_username/repo.svg?style=for-the-badge
[stars-url]: https://github.com/github_username/repo_name/stargazers
[issues-shield]: https://img.shields.io/github/issues/github_username/repo.svg?style=for-the-badge
[issues-url]: https://github.com/github_username/repo_name/issues
[license-shield]: https://img.shields.io/github/license/github_username/repo.svg?style=for-the-badge
[license-url]: https://github.com/github_username/repo_name/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/github_username
