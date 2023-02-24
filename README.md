# JobAds
<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
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
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <h1 align="center">Job Ads</h1>

  <p align="center">
    Management and analysis of data related to Glassdoor platform job postings
    <br />
    <a href="https://github.com/ClaudioPoli/JobAds/issues">Report Bug</a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
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
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project
Management of structured and unstructured data

Design and implementation of a database relating to ads placed on the Glassdoor platform, the development steps are listed below:
- Requirements analysis: understanding of the domain, definition of a preliminary sector scheme and of the operations that can be carried out by the system;
-Conceptual modeling: application of conceptual modeling techniques and definition of an object-oriented conceptual scheme;
- Logical modeling: application of logic modeling techniques and definition of a logical E-R scheme;
- Physical modeling: transformation of the logical scheme into a physical scheme through the use of DDL and DML necessary for the definition of a database;
-Operations: implementation of user operations regarding the management and analysis of data relating to the ads on the platform, their geographical position and the reviews associated with them through QL.


Software: draw.io [Conceptual / Logical Design], Datagrip [SQL IDE], Pycharm [Python IDE], GATE [NLP]

DBMS: PostgreSQL (PostGIS - geographic extension)

Pipeline NLP: Corpus PMI extraction, NER, Corpus Augmented TF-IDF / KyotoDomainRelevance extraction

Data source: 'https://www.kaggle.com/andresionek/data-jobs-listings-glassdoor'

<p align="right">(<a href="#readme-top">back to top</a>)</p>



### Built With
* [SQL][SQL-url]
* [Draw-io][Draw-io-url]
* [PostgreSQL][Postgre-url]


<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started
### Prerequisites

* PostgreSQL

### Installation
1. Clone the repo
   ```sh
   git clone https://github.com/ClaudioPoli/JobAds.git
   ```
2. That's it!

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage
The project involves creating a database in PostgreSQL using SQL scripts, in order you need to run:
- DDL
- Constraint
- DML

Subsequently it is possible to execute the scripts related to the queries useful for the extraction of different information. Executable queries can be found in:
- BenefitAnalysis
- NumberOfListings
- JobAnalysis
- IndustryAnalysis



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/othneildrew/Best-README-Template.svg?style=for-the-badge
[contributors-url]: https://github.com/othneildrew/Best-README-Template/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/othneildrew/Best-README-Template.svg?style=for-the-badge
[forks-url]: https://github.com/othneildrew/Best-README-Template/network/members
[stars-shield]: https://img.shields.io/github/stars/othneildrew/Best-README-Template.svg?style=for-the-badge
[stars-url]: https://github.com/othneildrew/Best-README-Template/stargazers
[issues-shield]: https://img.shields.io/github/issues/othneildrew/Best-README-Template.svg?style=for-the-badge
[issues-url]: https://github.com/othneildrew/Best-README-Template/issues
[license-shield]: https://img.shields.io/github/license/othneildrew/Best-README-Template.svg?style=for-the-badge
[license-url]: https://github.com/othneildrew/Best-README-Template/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/claudiopoli1995/
[product-screenshot]: images/screenshot.png
[SQL-url]: https://it.wikipedia.org/wiki/Structured_Query_Language
[Tableau-url]: https://www.tableau.com
[Draw-io-url]: https://app.diagrams.net
[Postgre-url]: https://www.postgresql.org