# Chicago-Schools-Parks-Analysis
With Third Spaces on a decline nationally, cities like Chicago are making an active effort to invest in the propagation of green spaces for their residents. While the topic of "Third Spaces" is often centered on adult experiences and health indicators, publications such as [Park access and mental health among parents and children during the COVID-19 pandemic](https://pmc.ncbi.nlm.nih.gov/articles/PMC9022731/) emphasize the effect of not just the presence of green spaces but their <b>proximity</b> as well:

> Greening schoolyards is an intervention to transform playgrounds into community parks, but this approach has primarily targeted elementary schools. Prior studies indicate improved academic performance and stress response in response to nearby nature on high school campuses [58, 59]. If schoolyard renovations that transform those spaces into community parks also target middle and high schools where youth spend much of their time, these spaces may be an important health resources for adolescents.

As such, in this project, I seek to explore just that. The City of Chicago provides a variety of datasets from various sources. In this project, I am using three datasets: the [2024 Report Card Public Data set](https://www.isbe.net/pages/illinois-state-report-card-data.aspx) provided by the Illinois State Board of Education; and the [Chicago Public Schools Profile Information 24-25](https://data.cityofchicago.org/Education/Chicago-Public-Schools-School-Profile-Information-/3dhs-m3w4/about_data) and the [Chicago Parks District](https://data.cityofchicago.org/Parks-Recreation/CPD_Parks/ejsh-fztr/about_data) dataset, both of which are provided via the Chicago Data Portal.

To begin exploring this data, I executed numerous data-cleaning tactics in Excel in order to prepare for my SQL Exploration. These tasks included:

<b>2024 REPORT CARD PUBLIC DATASET</b>
1. Limiting the data to include schools (1) only in the City of Chicago and (2) under the jurisdiction of Chicago Public Schools (CPS)
2. Removing irrelevant columns
3. Replacing empty fields with NULL

<b>CHICAGO PUBLIC SCHOOLS PROFILE INFORMATION 24-25</b>
1. Removing irrelevant columns
2. Replacing empty fields with NULL
3. Using xlookup to associate School_ID based on School Name
4. Confirming/Addressing duplicates for School_ID

<b>CHICAGO PARKS</b>
1. Removing irrelevant columns
2. Correcting sequencing for OBJECTID_1

At this stage, the datasets are ready to import into SQL!
