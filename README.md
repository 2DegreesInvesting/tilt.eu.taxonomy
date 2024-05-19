
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tilt.eu.taxonomy

<!-- badges: start -->

[![R-CMD-check](https://github.com/2DegreesInvesting/tilt.eu.taxonomy/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/2DegreesInvesting/tilt.eu.taxonomy/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of tilt.eu.taxonomy is to assess whether each product of the
SME is eligible for the EU taxonomy regulation.

## Installation

You can install the development version of tilt.eu.taxonomy from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("2DegreesInvesting/tilt.eu.taxonomy")
```

Or

``` r
# install.packages("pak")
pak::pak("2DegreesInvesting/tilt.eu.taxonomy")
```

## Testing EU Taxonomy Eligibility

The products of each Europages company are matched with the Ecoinvent
activities. To test whether Europages products are EU Taxonomy eligible,
we will match the Ecoinvent activities of these products with the EU
Taxonomy activities. The matching process determines whether the product
is taxonomy-eligible or not. If the Ecoinvent activity matches a
taxonomy activity, then it is classified as eligible. If the product
does not match any taxonomy activity, then it is classified as not
eligible.

## Setup

``` r
library(tilt.eu.taxonomy)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
options(readr.show_col_types = FALSE)
options(width = 300)
```

## Load Data

### Load Europages products matched with Ecoinvent activities

`ep_companies_ei_activities` is extracted from the dataframe
`profile_companies` created by the Python class `PCompanies` in the
`tiltIndicatorBefore` repository. It contains Europages companies and
products matched with Ecoinvent activities (along with `isic_4digit`).
We will select the product-level columns from the whole dataset.

``` r
ep_products_ei_activities_product <- ep_companies_ei_activities_at_product_level(ep_companies_ei_activities)
ep_products_ei_activities_product |>
  slice(1:5)
#> # A tibble: 5 × 4
#>   ep_product           activity_uuid_product_uuid                                                ecoinvent_activity_name                           isic_4digit
#>   <chr>                <chr>                                                                     <chr>                                             <chr>      
#> 1 ptfe sealing gaskets ff8730f0-d92e-54ed-9a8e-09fc7920cf87_888e7520-545c-4857-a07a-094575afe6ca sealing tape production, aluminium/PE, 50 mm wide 2220       
#> 2 bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f5ad71f section bar rolling, steel                        2410       
#> 3 cutting              53dae40f-2bf3-5063-9aeb-4e9de4375cc7_c17bc9a6-70c2-49c3-ad5e-16840fa81178 potato haulm cutting                              0161       
#> 4 ethyl alcohol        46ef86a4-d9d5-5185-a2df-94a57b0e7b6f_1a71f77c-edaa-4365-a192-f54ac538d033 ethyl acetate production                          2011       
#> 5 phenols              9f3b74f9-c86d-5866-992f-e7a04ac19653_55b66789-289c-4f21-8d9b-3236e726b933 phenol production, from cumene                    2011
```

### EU Taxonomy Activties of EU Taxonomy regulation objectives

EU Taxonomy Regulation sets out six climate and environmental
objectives. The six objectives are Climate change mitigation, Climate
change adaptation, Protection of water, Transition to a circular
economy, Pollution Prevention, and Protection of biodiversity. Each
objective outlines those activities which adhere to environmentally
sustainable standards. They also outline the information regarding their
contribution type, SCC alignment, and DNSH alignment. A subset of
activities which follow each objective:

``` r
# Climate change mitigation
eu_tax_climate_mitigation |>
  slice(11:12)
#> # A tibble: 2 × 12
#>   Activity                                     NACE                    Sector        `Activity number` `Contribution type` Description                                    Substantial contribu…¹ DNSH on Climate adap…² `DNSH on Water` DNSH on Circular eco…³ DNSH on Pollution pr…⁴ `DNSH on Biodiversity`
#>   <chr>                                        <chr>                   <chr>         <chr>             <chr>               <chr>                                          <chr>                  <chr>                  <chr>           <chr>                  <chr>                  <chr>                 
#> 1 Manufacture of other low carbon technologies C22, C25, C26, C27, C28 Manufacturing 3.6               Enabling            Manufacture of technologies aimed at substant… The economic activity… The activity complies… The activity c… The activity assesses… The activity complies… The activity complies…
#> 2 Manufacture of cement                        C23.51                  Manufacturing 3.7               Transitional        Manufacture of cement clinker, cement or alte… The activity manufact… The activity complies… The activity c… N/A                    The activity complies… The activity complies…
#> # ℹ abbreviated names: ¹​`Substantial contribution criteria`, ²​`DNSH on Climate adaptation`, ³​`DNSH on Circular economy`, ⁴​`DNSH on Pollution prevention`
```

``` r
# Climate change adaptation
eu_tax_climate_adaptation |>
  slice(1:2)
#> # A tibble: 2 × 12
#>   Activity                                                                                                 NACE  Sector `Activity number` `Contribution type` Description Substantial contribu…¹ DNSH on Climate miti…² `DNSH on Water` DNSH on Circular eco…³ DNSH on Pollution pr…⁴ `DNSH on Biodiversity`
#>   <chr>                                                                                                    <chr> <chr>  <chr>             <chr>               <chr>       <chr>                  <chr>                  <chr>           <chr>                  <chr>                  <chr>                 
#> 1 Afforestation                                                                                            A2    Fores… 1.1               Enabling            Establishm… 1. The economic activ… 1. Afforestation plan… The activity c… N/A                    The use of pesticides… In areas designated b…
#> 2 Rehabilitation and restoration of forests, including reforestation and natural forest regeneration afte… A2    Fores… 1.2               Enabling            Rehabilita… 1. The economic activ… 1. Forest management … The activity c… The silvicultural cha… The use of pesticides… In areas designated b…
#> # ℹ abbreviated names: ¹​`Substantial contribution criteria`, ²​`DNSH on Climate mitigation`, ³​`DNSH on Circular economy`, ⁴​`DNSH on Pollution prevention`
```

``` r
# Protection of water
eu_tax_water_protection |>
  slice(2:3)
#> # A tibble: 2 × 12
#>   Activity                    NACE          Sector                                                   `Activity number` `Contribution type` Description             Substantial contribu…¹ DNSH on Climate miti…² DNSH on Climate adap…³ DNSH on Circular eco…⁴ DNSH on Pollution pr…⁵ `DNSH on Biodiversity`
#>   <chr>                       <chr>         <chr>                                                    <chr>             <chr>               <chr>                   <chr>                  <chr>                  <chr>                  <chr>                  <chr>                  <chr>                 
#> 1 Water supply                E36.00, F42.9 Water supply, sewerage, waste management and remediation 2.1               <NA>                Construction, extensio… 1. For the operation … N/A                    The activity complies… N/A                    N/A                    The activity complies…
#> 2 Urban Waste Water Treatment E37.00, F42.9 Water supply, sewerage, waste management and remediation 2.2               <NA>                Construction, extensio… 1. The waste water tr… An assessment of the … The activity complies… N/A                    Discharges to receivi… The activity complies…
#> # ℹ abbreviated names: ¹​`Substantial contribution criteria`, ²​`DNSH on Climate mitigation`, ³​`DNSH on Climate adaptation`, ⁴​`DNSH on Circular economy`, ⁵​`DNSH on Pollution prevention`
```

``` r
# Transition to a Circular Economy
eu_tax_circular_economy_transition |>
  slice(1:2)
#> # A tibble: 2 × 12
#>   Activity                                           NACE     Sector        `Activity number` `Contribution type` Description                                             Substantial contribu…¹ DNSH on Climate miti…² DNSH on Climate adap…³ `DNSH on Water` DNSH on Pollution pr…⁴ `DNSH on Biodiversity`
#>   <chr>                                              <chr>    <chr>         <chr>             <chr>               <chr>                                                   <chr>                  <chr>                  <chr>                  <chr>           <chr>                  <chr>                 
#> 1 Manufacture of plastic packaging goods             C22.22   Manufacturing 1.1               <NA>                Manufacture of plastic packaging goods.The economic ac… 1. The activity compl… For plastic manufactu… The activity complies… The activity c… The activity complies… The activity complies…
#> 2 Manufacture of electrical and electronic equipment C26, C27 Manufacturing 1.2               <NA>                Manufacturing of electrical and electronic equipment f… 1. Where the economic… Where the manufacture… The activity complies… The activity c… The activity complies… The activity complies…
#> # ℹ abbreviated names: ¹​`Substantial contribution criteria`, ²​`DNSH on Climate mitigation`, ³​`DNSH on Climate adaptation`, ⁴​`DNSH on Pollution prevention`
```

``` r
# Pollution Prevention
eu_tax_pollution_prevention |>
  slice(1:2)
#> # A tibble: 2 × 12
#>   Activity                                                                    NACE  Sector        `Activity number` `Contribution type` Description                       Substantial contribu…¹ DNSH on Climate miti…² DNSH on Climate adap…³ `DNSH on Water` DNSH on Circular eco…⁴ `DNSH on Biodiversity`
#>   <chr>                                                                       <chr> <chr>         <chr>             <lgl>               <chr>                             <chr>                  <chr>                  <chr>                  <chr>           <chr>                  <chr>                 
#> 1 Manufacture of active pharmaceutical ingredients (API) or active substances C21.1 Manufacturing 1.1               NA                  Manufacture of active pharmaceut… 1. The activity compl… Where the activity in… The activity complies… 1. Waste water… The activity assesses… The activity complies…
#> 2 Manufacture of medicinal products                                           C21.2 Manufacturing 1.2               NA                  Manufacture of medicinal product… 1. The activity compl… Where the activity in… The activity complies… 1. Waste water… The activity assesses… The activity complies…
#> # ℹ abbreviated names: ¹​`Substantial contribution criteria`, ²​`DNSH on Climate mitigation`, ³​`DNSH on Climate adaptation`, ⁴​`DNSH on Circular economy`
```

``` r
# Protection and restoration of Biodiversity
eu_tax_biodiversity_protection |>
  slice(1:5)
#> # A tibble: 2 × 12
#>   Activity                                                                       NACE                   Sector          `Activity number` `Contribution type` Description Substantial contribu…¹ DNSH on Climate miti…² DNSH on Climate adap…³ `DNSH on Water` DNSH on Circular eco…⁴ DNSH on Pollution pr…⁵
#>   <chr>                                                                          <chr>                  <chr>           <chr>             <lgl>               <chr>       <chr>                  <chr>                  <chr>                  <chr>           <chr>                  <chr>                 
#> 1 Conservation, including restoration, of habitats[1], ecosystems[2] and species <NA>                   Environmental … 1.1               NA                  Initiation… "1. General condition… The activity does not… The activity complies… The activity c… N/A                    The use of pesticides…
#> 2 Hotels, holiday, camping grounds and similar accommodation                     I55.10, I55.20, I55.30 Accommodation … 2.1               NA                  The provis… "1. Contribution to c… For buildings built b… The activity complies… The activity c… The accommodation est… The activity complies…
#> # ℹ abbreviated names: ¹​`Substantial contribution criteria`, ²​`DNSH on Climate mitigation`, ³​`DNSH on Climate adaptation`, ⁴​`DNSH on Circular economy`, ⁵​`DNSH on Pollution prevention`
```

### EU Taxonomy Activities’ keywords

This prototype focuses on a small subset of 7 taxonomy activities which
are shown below. Each taxonomy activity is assigned domain-specific
keywords which are chosen manually and with the help of OpenAI’s ChatGPT
model. They are used to improve the quality of the match between
Ecoinevnt activities and EU Taxonomy activities by searching each
keyword in the matched ecoinvent activity. Only those EU Taxonomy
activities are selected as good matches which have at least one keyword
present in the matched ecoinvent activity.

``` r
eu_tax_activities_keywords
#> # A tibble: 7 × 2
#>   tax_activity                                                                                                              tax_activity_keywords                                                                                                                                                           
#>   <chr>                                                                                                                     <chr>                                                                                                                                                                           
#> 1 Afforestation                                                                                                             silviculture; afforestation; planting trees; nurturing trees; harvesting trees; forestry activities; forest management; forest maintenance; restore land; logging               
#> 2 Rehabilitation and restoration of forests, including reforestation and natural forest regeneration after an extreme event reforestation; timber harvesting; non-wood collection; forestry support; forest rehabilitation; forest regeneration                                                             
#> 3 Forest management                                                                                                         silviculture; logging; non-wood gathering; forestry support                                                                                                                     
#> 4 Manufacture of iron and steel                                                                                             iron; steel; ferrous metal; metal; metallurgical; ferrous alloy; steelworks; alloy                                                                                              
#> 5 Manufacture of chlorine                                                                                                   chlorine; sodium chloride; chlor-alkali                                                                                                                                         
#> 6 Manufacture of organic basic chemicals                                                                                    acetylene; ethylene; propylene; butadiene; mixed alkylbenzenes; mixed alkylnaphthalenes; cyclohexane; benzene; xylene isomers; ethylbenzene; cumene; biphenyl; terphenyls; viny…
#> 7 Manufacture of plastics in primary form                                                                                   resin; plastic; thermoplastic elastomer
```

### Load NACE-ISIC sector mapper

NACE-ISIC sector mapper serves as the activity matching bridge between
the Ecoinvent activities and EU Taxonomy activities.

``` r
isic_nace_mapper |>
  slice(1:5)
#>    NACE ISIC
#> 1     A    A
#> 2    A1   01
#> 3  A1.1  011
#> 4 A1.11 0111
#> 5 A1.12 0112
```

## All EU Taxonomy activities with keywords

This step collects all EU Taxonomy activities into a single table from
six objective tables. Then, each activity will be assigned
domain-specific keywords using `eu_tax_activities_keywords`. We have
assigned keywords to only 7 taxonomy activities, hence we will filter
out other taxonomy activities in this example.

``` r
eu_tax_activities_all_with_keywords <- eu_tax_activities_all(
  eu_tax_climate_mitigation, eu_tax_climate_adaptation,
  eu_tax_water_protection, eu_tax_circular_economy_transition,
  eu_tax_pollution_prevention, eu_tax_biodiversity_protection
) |>
  eu_tax_activities_all_with_keywords(eu_tax_activities_keywords) |>
  filter(!is.na(tax_activity_keywords))

eu_tax_activities_all_with_keywords |>
  slice(1:10)
#> # A tibble: 10 × 4
#>    tax_activity                                                                                                              nace   tax_activity_description                                                                                                                           tax_activity_keywords
#>    <chr>                                                                                                                     <chr>  <chr>                                                                                                                                              <chr>                
#>  1 Afforestation                                                                                                             A2     Establishment of forest through planting, deliberate seeding or natural regeneration on land that, until then, was under a different land use or … silviculture; affore…
#>  2 Rehabilitation and restoration of forests, including reforestation and natural forest regeneration after an extreme event A2     Rehabilitation and restoration of forests as defined by national law. Where national law does not contain such a definition, rehabilitation and r… reforestation; timbe…
#>  3 Forest management                                                                                                         A2     Forest management as defined by national law. Where national law does not contain such a definition, forest management corresponds to any economi… silviculture; loggin…
#>  4 Manufacture of iron and steel                                                                                             C24.10 Manufacture of iron and steel. The economic activities in this category could be associated with several NACE codes, in particular C24.10, C24.20… iron; steel; ferrous…
#>  5 Manufacture of iron and steel                                                                                             C24.20 Manufacture of iron and steel. The economic activities in this category could be associated with several NACE codes, in particular C24.10, C24.20… iron; steel; ferrous…
#>  6 Manufacture of iron and steel                                                                                             C24.31 Manufacture of iron and steel. The economic activities in this category could be associated with several NACE codes, in particular C24.10, C24.20… iron; steel; ferrous…
#>  7 Manufacture of iron and steel                                                                                             C24.32 Manufacture of iron and steel. The economic activities in this category could be associated with several NACE codes, in particular C24.10, C24.20… iron; steel; ferrous…
#>  8 Manufacture of iron and steel                                                                                             C24.33 Manufacture of iron and steel. The economic activities in this category could be associated with several NACE codes, in particular C24.10, C24.20… iron; steel; ferrous…
#>  9 Manufacture of iron and steel                                                                                             C24.34 Manufacture of iron and steel. The economic activities in this category could be associated with several NACE codes, in particular C24.10, C24.20… iron; steel; ferrous…
#> 10 Manufacture of iron and steel                                                                                             C24.51 Manufacture of iron and steel. The economic activities in this category could be associated with several NACE codes, in particular C24.10, C24.20… iron; steel; ferrous…
```

## Matching NACE codes to Ecoinvent activities

NACE sector codes are used to match Ecoinvent activities with EU
Taxonomy activities. Ecoinvent activities table
`ep_products_ei_activities` don’t have NACE codes. As a first step, to
match NACE codes to `ep_products_ei_activities`, we will use the ISIC
sector codes as the mapper present in the `nace_isic_mapper` file.

``` r
ecoinvent_activities_with_nace <- ecoinvent_activities_with_nace(ep_products_ei_activities_product, isic_nace_mapper)
ecoinvent_activities_with_nace |>
  slice(1:5)
#> # A tibble: 5 × 5
#>   ep_product           activity_uuid_product_uuid                                                ecoinvent_activity_name                           isic_4digit NACE  
#>   <chr>                <chr>                                                                     <chr>                                             <chr>       <chr> 
#> 1 ptfe sealing gaskets ff8730f0-d92e-54ed-9a8e-09fc7920cf87_888e7520-545c-4857-a07a-094575afe6ca sealing tape production, aluminium/PE, 50 mm wide 2220        C22.21
#> 2 ptfe sealing gaskets ff8730f0-d92e-54ed-9a8e-09fc7920cf87_888e7520-545c-4857-a07a-094575afe6ca sealing tape production, aluminium/PE, 50 mm wide 2220        C22.22
#> 3 ptfe sealing gaskets ff8730f0-d92e-54ed-9a8e-09fc7920cf87_888e7520-545c-4857-a07a-094575afe6ca sealing tape production, aluminium/PE, 50 mm wide 2220        C22.23
#> 4 ptfe sealing gaskets ff8730f0-d92e-54ed-9a8e-09fc7920cf87_888e7520-545c-4857-a07a-094575afe6ca sealing tape production, aluminium/PE, 50 mm wide 2220        C22.29
#> 5 bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f5ad71f section bar rolling, steel                        2410        C24.10
```

## Matching Ecoinvent activities (with NACE) to EU Taxonomy activities

NACE codes are used to match Ecoinvent activities and EU Taxonomy
activities. Both the tables `eu_tax_activities_all_with_keywords` and
`ecoinvent_activities_with_nace` have the NACE codes. After matching
Ecoinvent activities and EU Taxonomy activities, there is a one-to-many
relationship between taxonomy activities and Ecoinvent activities
respectively. This means that a single taxonomy activity is related to
multiple ecoinvent activities.

``` r
ecoinvent_activities_eu_tax_activities <- ecoinvent_activities_eu_tax_activities(ecoinvent_activities_with_nace, eu_tax_activities_all_with_keywords)
ecoinvent_activities_eu_tax_activities
#> # A tibble: 253 × 8
#>    ep_product           activity_uuid_product_uuid                                                ecoinvent_activity_name                           isic_4digit NACE   tax_activity                  tax_activity_description                                                          tax_activity_keywords
#>    <chr>                <chr>                                                                     <chr>                                             <chr>       <chr>  <chr>                         <chr>                                                                             <chr>                
#>  1 ptfe sealing gaskets ff8730f0-d92e-54ed-9a8e-09fc7920cf87_888e7520-545c-4857-a07a-094575afe6ca sealing tape production, aluminium/PE, 50 mm wide 2220        C22.21 <NA>                          <NA>                                                                              <NA>                 
#>  2 ptfe sealing gaskets ff8730f0-d92e-54ed-9a8e-09fc7920cf87_888e7520-545c-4857-a07a-094575afe6ca sealing tape production, aluminium/PE, 50 mm wide 2220        C22.22 <NA>                          <NA>                                                                              <NA>                 
#>  3 ptfe sealing gaskets ff8730f0-d92e-54ed-9a8e-09fc7920cf87_888e7520-545c-4857-a07a-094575afe6ca sealing tape production, aluminium/PE, 50 mm wide 2220        C22.23 <NA>                          <NA>                                                                              <NA>                 
#>  4 ptfe sealing gaskets ff8730f0-d92e-54ed-9a8e-09fc7920cf87_888e7520-545c-4857-a07a-094575afe6ca sealing tape production, aluminium/PE, 50 mm wide 2220        C22.29 <NA>                          <NA>                                                                              <NA>                 
#>  5 bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f5ad71f section bar rolling, steel                        2410        C24.10 Manufacture of iron and steel Manufacture of iron and steel. The economic activities in this category could be… iron; steel; ferrous…
#>  6 bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f5ad71f section bar rolling, steel                        2410        C24.20 Manufacture of iron and steel Manufacture of iron and steel. The economic activities in this category could be… iron; steel; ferrous…
#>  7 bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f5ad71f section bar rolling, steel                        2410        C24.31 Manufacture of iron and steel Manufacture of iron and steel. The economic activities in this category could be… iron; steel; ferrous…
#>  8 bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f5ad71f section bar rolling, steel                        2410        C24.32 Manufacture of iron and steel Manufacture of iron and steel. The economic activities in this category could be… iron; steel; ferrous…
#>  9 bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f5ad71f section bar rolling, steel                        2410        C24.33 Manufacture of iron and steel Manufacture of iron and steel. The economic activities in this category could be… iron; steel; ferrous…
#> 10 bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f5ad71f section bar rolling, steel                        2410        C24.34 Manufacture of iron and steel Manufacture of iron and steel. The economic activities in this category could be… iron; steel; ferrous…
#> # ℹ 243 more rows
```

## Keywords search to validate match between Ecoinvent activities and EU Taxonomy activities

As there is a one-to-many relationship between taxonomy activities and
Ecoinvent activities, there is a high chance that we might get bad
matches between activities. Hence, `taxonomy_keywords` will be used to
check whether ecoinvent activities are a closer match to the matched
taxonomy activities or not. Each keyword is separated by a semicolon
(;), and any value between consecutive semicolons will be matched with
ecoinvent activity. If a single taxonomy keyword is present in the
`ecoinvent_activity_name` column, the presence is stated with “TRUE” in
the `keyword_is_present` column. And “FALSE” is stated if the keyword is
not present.

``` r
eco_activities_after_keywords_search <- eco_activities_after_keywords_search(ecoinvent_activities_eu_tax_activities)
eco_activities_after_keywords_search |>
  slice(1:10)
#> # A tibble: 10 × 9
#>    ep_product           activity_uuid_product_uuid                                                ecoinvent_activity_name                           isic_4digit NACE   tax_activity                  tax_activity_description                                       tax_activity_keywords keyword_is_present
#>    <chr>                <chr>                                                                     <chr>                                             <chr>       <chr>  <chr>                         <chr>                                                          <chr>                 <lgl>             
#>  1 ptfe sealing gaskets ff8730f0-d92e-54ed-9a8e-09fc7920cf87_888e7520-545c-4857-a07a-094575afe6ca sealing tape production, aluminium/PE, 50 mm wide 2220        C22.21 <NA>                          <NA>                                                           <NA>                  FALSE             
#>  2 ptfe sealing gaskets ff8730f0-d92e-54ed-9a8e-09fc7920cf87_888e7520-545c-4857-a07a-094575afe6ca sealing tape production, aluminium/PE, 50 mm wide 2220        C22.22 <NA>                          <NA>                                                           <NA>                  FALSE             
#>  3 ptfe sealing gaskets ff8730f0-d92e-54ed-9a8e-09fc7920cf87_888e7520-545c-4857-a07a-094575afe6ca sealing tape production, aluminium/PE, 50 mm wide 2220        C22.23 <NA>                          <NA>                                                           <NA>                  FALSE             
#>  4 ptfe sealing gaskets ff8730f0-d92e-54ed-9a8e-09fc7920cf87_888e7520-545c-4857-a07a-094575afe6ca sealing tape production, aluminium/PE, 50 mm wide 2220        C22.29 <NA>                          <NA>                                                           <NA>                  FALSE             
#>  5 bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f5ad71f section bar rolling, steel                        2410        C24.10 Manufacture of iron and steel Manufacture of iron and steel. The economic activities in thi… iron; steel; ferrous… TRUE              
#>  6 bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f5ad71f section bar rolling, steel                        2410        C24.20 Manufacture of iron and steel Manufacture of iron and steel. The economic activities in thi… iron; steel; ferrous… TRUE              
#>  7 bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f5ad71f section bar rolling, steel                        2410        C24.31 Manufacture of iron and steel Manufacture of iron and steel. The economic activities in thi… iron; steel; ferrous… TRUE              
#>  8 bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f5ad71f section bar rolling, steel                        2410        C24.32 Manufacture of iron and steel Manufacture of iron and steel. The economic activities in thi… iron; steel; ferrous… TRUE              
#>  9 bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f5ad71f section bar rolling, steel                        2410        C24.33 Manufacture of iron and steel Manufacture of iron and steel. The economic activities in thi… iron; steel; ferrous… TRUE              
#> 10 bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f5ad71f section bar rolling, steel                        2410        C24.34 Manufacture of iron and steel Manufacture of iron and steel. The economic activities in thi… iron; steel; ferrous… TRUE
```

## ChatGPT match validation between Ecoinvent activities and EU Taxonomy activities’ description

The EU taxonomy provides a description column for each taxonomy activity
which contains more information about them. Hence, we propose to use
this additional information to validate whether the ecoinvent activities
will be covered by the taxonomy activity description or not. ChatGPT is
used to validate the same using `Yes` (covered well) and `No` (not
covered well) for each matched `ecoinvent_activity_name` and
`tax_activity_description`. We used OpenAI’s `gpt-4-turbo` model for
validation with the following prompt:

    "We have a dataframe with columns 'ecoinvent_activity_name' and
    'taxonomy_activity_description'. Check row wise whether the ecoinvent activity
    (column 'ecoinvent_activity_name') covered by the EU Taxonomy activity description
    (column 'taxonomy_activity_description'). Please provide only one word answer
    with `Yes` or `No` without any explaination, where `Yes` means covered well and
    `No` means not covered well.
    "

``` r
eco_activities_after_gpt_validation <- eco_activities_gpt_validation(eco_activities_after_keywords_search)
eco_activities_after_gpt_validation |>
  slice(1:10)
#> # A tibble: 10 × 10
#>    ep_product           activity_uuid_product_uuid                                                ecoinvent_activity_name                           isic_4digit NACE   tax_activity                  tax_activity_description                        tax_activity_keywords keyword_is_present gpt_validation
#>    <chr>                <chr>                                                                     <chr>                                             <chr>       <chr>  <chr>                         <chr>                                           <chr>                 <lgl>              <chr>         
#>  1 ptfe sealing gaskets ff8730f0-d92e-54ed-9a8e-09fc7920cf87_888e7520-545c-4857-a07a-094575afe6ca sealing tape production, aluminium/PE, 50 mm wide 2220        C22.21 <NA>                          <NA>                                            <NA>                  FALSE              No            
#>  2 ptfe sealing gaskets ff8730f0-d92e-54ed-9a8e-09fc7920cf87_888e7520-545c-4857-a07a-094575afe6ca sealing tape production, aluminium/PE, 50 mm wide 2220        C22.22 <NA>                          <NA>                                            <NA>                  FALSE              No            
#>  3 ptfe sealing gaskets ff8730f0-d92e-54ed-9a8e-09fc7920cf87_888e7520-545c-4857-a07a-094575afe6ca sealing tape production, aluminium/PE, 50 mm wide 2220        C22.23 <NA>                          <NA>                                            <NA>                  FALSE              No            
#>  4 ptfe sealing gaskets ff8730f0-d92e-54ed-9a8e-09fc7920cf87_888e7520-545c-4857-a07a-094575afe6ca sealing tape production, aluminium/PE, 50 mm wide 2220        C22.29 <NA>                          <NA>                                            <NA>                  FALSE              No            
#>  5 bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f5ad71f section bar rolling, steel                        2410        C24.10 Manufacture of iron and steel Manufacture of iron and steel. The economic ac… iron; steel; ferrous… TRUE               Yes           
#>  6 bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f5ad71f section bar rolling, steel                        2410        C24.20 Manufacture of iron and steel Manufacture of iron and steel. The economic ac… iron; steel; ferrous… TRUE               Yes           
#>  7 bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f5ad71f section bar rolling, steel                        2410        C24.31 Manufacture of iron and steel Manufacture of iron and steel. The economic ac… iron; steel; ferrous… TRUE               Yes           
#>  8 bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f5ad71f section bar rolling, steel                        2410        C24.32 Manufacture of iron and steel Manufacture of iron and steel. The economic ac… iron; steel; ferrous… TRUE               Yes           
#>  9 bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f5ad71f section bar rolling, steel                        2410        C24.33 Manufacture of iron and steel Manufacture of iron and steel. The economic ac… iron; steel; ferrous… TRUE               Yes           
#> 10 bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f5ad71f section bar rolling, steel                        2410        C24.34 Manufacture of iron and steel Manufacture of iron and steel. The economic ac… iron; steel; ferrous… TRUE               Yes
```

## EU Taxonomy-eligible Europages products

The Europages products which have “TRUE” in `keyword_is_present` column
and “Yes” in `gpt_validation` column are considered EU Taxonomy-eligible
because they are matched with EU Taxonomy activities (via ecoinvent
activities) after ISIC-NACE mapping, keywords search, and ChatGPT
validation. Here is a list of a small subset of EU Taxonomy-eligible
Europages products:

``` r
tax_eligible_ep_products <- taxonomy_eligible(eco_activities_after_gpt_validation)
tax_eligible_ep_products |>
  slice(30:34)
#> # A tibble: 5 × 10
#>   ep_product            activity_uuid_product_uuid                                                ecoinvent_activity_name                                         isic_4digit NACE   tax_activity                            tax_activity_descript…¹ tax_activity_keywords keyword_is_present gpt_validation
#>   <chr>                 <chr>                                                                     <chr>                                                           <chr>       <chr>  <chr>                                   <chr>                   <chr>                 <lgl>              <chr>         
#> 1 coating resins        48b91475-858c-5095-8080-b1daa4edb825_e28d7a4d-fb38-4f5e-aac0-359ecef77b45 orthophthalic acid based unsaturated polyester resin production 2013        C20.16 Manufacture of plastics in primary form Manufacture resins, pl… resin; plastic; ther… TRUE               Yes           
#> 2 thermoset parts       2b72139e-d6d5-5312-bf0f-d2b0b544228f_ffa87882-6302-430b-a4c2-45426a006ed7 isophthalic acid based unsaturated polyester resin production   2013        C20.16 Manufacture of plastics in primary form Manufacture resins, pl… resin; plastic; ther… TRUE               Yes           
#> 3 hand tools, non-power 985df177-4c01-544c-8740-4d019ee28fd7_fe95f2c3-b749-489d-ae35-6900865e6a48 forging, steel, large open die                                  2410        C24.10 Manufacture of iron and steel           Manufacture of iron an… iron; steel; ferrous… TRUE               Yes           
#> 4 hand tools, non-power 985df177-4c01-544c-8740-4d019ee28fd7_fe95f2c3-b749-489d-ae35-6900865e6a48 forging, steel, large open die                                  2410        C24.20 Manufacture of iron and steel           Manufacture of iron an… iron; steel; ferrous… TRUE               Yes           
#> 5 hand tools, non-power 985df177-4c01-544c-8740-4d019ee28fd7_fe95f2c3-b749-489d-ae35-6900865e6a48 forging, steel, large open die                                  2410        C24.31 Manufacture of iron and steel           Manufacture of iron an… iron; steel; ferrous… TRUE               Yes           
#> # ℹ abbreviated name: ¹​tax_activity_description
```

## EU Taxonomy Indicator at company level

After identifying Europages products which are EU Taxonomy-eligible, we
want to find out which Europages companies have taxonomy-eligible
Europages products. This section loads company level columns and then
joins them with matched ecoinvent activities after gpt validation.
Lastly, final step filters the Europages companies which have
taxonomy-eligible Europages products.

### Load company-level columns from `ep_companies_ei_activities` dataset

``` r
ep_products_ei_activities_company <- ep_companies_ei_activities_at_company_level(ep_companies_ei_activities)
ep_products_ei_activities_company |>
  slice(1:10)
#> # A tibble: 10 × 5
#>    companies_id                            company_name               country ep_product                  activity_uuid_product_uuid                                               
#>    <chr>                                   <chr>                      <chr>   <chr>                       <chr>                                                                    
#>  1 ajtm-joints-detancheite_fra599358-00101 ajtm - joints d'étanchéité france  ptfe sealing gaskets        ff8730f0-d92e-54ed-9a8e-09fc7920cf87_888e7520-545c-4857-a07a-094575afe6ca
#>  2 ajtm-joints-detancheite_fra599358-00101 ajtm - joints d'étanchéité france  bending                     77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f5ad71f
#>  3 ajtm-joints-detancheite_fra599358-00101 ajtm - joints d'étanchéité france  cutting                     53dae40f-2bf3-5063-9aeb-4e9de4375cc7_c17bc9a6-70c2-49c3-ad5e-16840fa81178
#>  4 cades-penedes_00000003942579-001        cades penedes              spain   ethyl alcohol               46ef86a4-d9d5-5185-a2df-94a57b0e7b6f_1a71f77c-edaa-4365-a192-f54ac538d033
#>  5 cades-penedes_00000003942579-001        cades penedes              spain   phenols                     9f3b74f9-c86d-5866-992f-e7a04ac19653_55b66789-289c-4f21-8d9b-3236e726b933
#>  6 cades-penedes_00000003942579-001        cades penedes              spain   derivatives                 9917da7b-013f-5175-84eb-e337fbd13c3e_9f2fdfd0-e173-47e9-812f-2bee762d9d39
#>  7 cades-penedes_00000003942579-001        cades penedes              spain   tartaric acid               b1cde6f9-fe23-5654-b1f5-6896f8da4906_9d63da75-8289-4b96-a900-67ec3bd40a16
#>  8 carlemsaph_00000005472318-001           carlemsaph                 france  pharmaceutical raw material 5c5d1cdb-22df-5e58-a3c7-500e031f03e7_dc1ed0ff-fbaa-47a1-8962-4faff492788f
#>  9 carlemsaph_00000005472318-001           carlemsaph                 france  cosmetic                    67d97fc9-5854-547e-8c64-84f0deb101ad_779bed36-7f72-4921-b677-e92df06db499
#> 10 carlemsaph_00000005472318-001           carlemsaph                 france  natural ingredient          82b0b82a-5afb-5078-ac5b-858549881b8b_e303fb73-b0e1-41ae-bddc-5e0e444eb3fb
```

### Join matched ecoinvent activties after gpt validation to Europages companies

``` r
companies_matched_eco_activities <- ep_companies_join_matched_eco_activities(ep_products_ei_activities_company, eco_activities_after_gpt_validation)
companies_matched_eco_activities |>
  slice(1:10)
#> # A tibble: 10 × 13
#>    companies_id                            company_name               country ep_product           activity_uuid_product_uuid                                           ecoinvent_activity_n…¹ isic_4digit NACE  tax_activity tax_activity_descrip…² tax_activity_keywords keyword_is_present gpt_validation
#>    <chr>                                   <chr>                      <chr>   <chr>                <chr>                                                                <chr>                  <chr>       <chr> <chr>        <chr>                  <chr>                 <lgl>              <chr>         
#>  1 ajtm-joints-detancheite_fra599358-00101 ajtm - joints d'étanchéité france  ptfe sealing gaskets ff8730f0-d92e-54ed-9a8e-09fc7920cf87_888e7520-545c-4857-a07a-094575… sealing tape producti… 2220        C22.… <NA>         <NA>                   <NA>                  FALSE              No            
#>  2 ajtm-joints-detancheite_fra599358-00101 ajtm - joints d'étanchéité france  ptfe sealing gaskets ff8730f0-d92e-54ed-9a8e-09fc7920cf87_888e7520-545c-4857-a07a-094575… sealing tape producti… 2220        C22.… <NA>         <NA>                   <NA>                  FALSE              No            
#>  3 ajtm-joints-detancheite_fra599358-00101 ajtm - joints d'étanchéité france  ptfe sealing gaskets ff8730f0-d92e-54ed-9a8e-09fc7920cf87_888e7520-545c-4857-a07a-094575… sealing tape producti… 2220        C22.… <NA>         <NA>                   <NA>                  FALSE              No            
#>  4 ajtm-joints-detancheite_fra599358-00101 ajtm - joints d'étanchéité france  ptfe sealing gaskets ff8730f0-d92e-54ed-9a8e-09fc7920cf87_888e7520-545c-4857-a07a-094575… sealing tape producti… 2220        C22.… <NA>         <NA>                   <NA>                  FALSE              No            
#>  5 ajtm-joints-detancheite_fra599358-00101 ajtm - joints d'étanchéité france  bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f… section bar rolling, … 2410        C24.… Manufacture… Manufacture of iron a… iron; steel; ferrous… TRUE               Yes           
#>  6 ajtm-joints-detancheite_fra599358-00101 ajtm - joints d'étanchéité france  bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f… section bar rolling, … 2410        C24.… Manufacture… Manufacture of iron a… iron; steel; ferrous… TRUE               Yes           
#>  7 ajtm-joints-detancheite_fra599358-00101 ajtm - joints d'étanchéité france  bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f… section bar rolling, … 2410        C24.… Manufacture… Manufacture of iron a… iron; steel; ferrous… TRUE               Yes           
#>  8 ajtm-joints-detancheite_fra599358-00101 ajtm - joints d'étanchéité france  bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f… section bar rolling, … 2410        C24.… Manufacture… Manufacture of iron a… iron; steel; ferrous… TRUE               Yes           
#>  9 ajtm-joints-detancheite_fra599358-00101 ajtm - joints d'étanchéité france  bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f… section bar rolling, … 2410        C24.… Manufacture… Manufacture of iron a… iron; steel; ferrous… TRUE               Yes           
#> 10 ajtm-joints-detancheite_fra599358-00101 ajtm - joints d'étanchéité france  bending              77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb-c7a28f… section bar rolling, … 2410        C24.… Manufacture… Manufacture of iron a… iron; steel; ferrous… TRUE               Yes           
#> # ℹ abbreviated names: ¹​ecoinvent_activity_name, ²​tax_activity_description
```

### EU Taxonomy-eligible Europages companies

``` r
tax_eligible_ep_companies <- taxonomy_eligible(companies_matched_eco_activities)
tax_eligible_ep_companies |>
  slice(1:10)
#> # A tibble: 10 × 13
#>    companies_id                            company_name               country ep_product                  activity_uuid_product_uuid                                    ecoinvent_activity_n…¹ isic_4digit NACE  tax_activity tax_activity_descrip…² tax_activity_keywords keyword_is_present gpt_validation
#>    <chr>                                   <chr>                      <chr>   <chr>                       <chr>                                                         <chr>                  <chr>       <chr> <chr>        <chr>                  <chr>                 <lgl>              <chr>         
#>  1 ajtm-joints-detancheite_fra599358-00101 ajtm - joints d'étanchéité france  bending                     77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb… section bar rolling, … 2410        C24.… Manufacture… Manufacture of iron a… iron; steel; ferrous… TRUE               Yes           
#>  2 ajtm-joints-detancheite_fra599358-00101 ajtm - joints d'étanchéité france  bending                     77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb… section bar rolling, … 2410        C24.… Manufacture… Manufacture of iron a… iron; steel; ferrous… TRUE               Yes           
#>  3 ajtm-joints-detancheite_fra599358-00101 ajtm - joints d'étanchéité france  bending                     77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb… section bar rolling, … 2410        C24.… Manufacture… Manufacture of iron a… iron; steel; ferrous… TRUE               Yes           
#>  4 ajtm-joints-detancheite_fra599358-00101 ajtm - joints d'étanchéité france  bending                     77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb… section bar rolling, … 2410        C24.… Manufacture… Manufacture of iron a… iron; steel; ferrous… TRUE               Yes           
#>  5 ajtm-joints-detancheite_fra599358-00101 ajtm - joints d'étanchéité france  bending                     77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb… section bar rolling, … 2410        C24.… Manufacture… Manufacture of iron a… iron; steel; ferrous… TRUE               Yes           
#>  6 ajtm-joints-detancheite_fra599358-00101 ajtm - joints d'étanchéité france  bending                     77ac10a7-6b05-5e27-8e5c-4358517b1ef6_8aa5cd19-c1ca-49f1-8efb… section bar rolling, … 2410        C24.… Manufacture… Manufacture of iron a… iron; steel; ferrous… TRUE               Yes           
#>  7 cades-penedes_00000003942579-001        cades penedes              spain   phenols                     9f3b74f9-c86d-5866-992f-e7a04ac19653_55b66789-289c-4f21-8d9b… phenol production, fr… 2011        C20.… Manufacture… Manufacture of: high … acetylene; ethylene;… TRUE               Yes           
#>  8 cades-penedes_00000003942579-001        cades penedes              spain   phenols                     9f3b74f9-c86d-5866-992f-e7a04ac19653_55b66789-289c-4f21-8d9b… phenol production, fr… 2011        C20.… Manufacture… Manufacture of:high v… acetylene; ethylene;… TRUE               Yes           
#>  9 carlemsaph_00000005472318-001           carlemsaph                 france  pharmaceutical raw material 5c5d1cdb-22df-5e58-a3c7-500e031f03e7_dc1ed0ff-fbaa-47a1-8962… market for propylene … 2011        C20.… Manufacture… Manufacture of: high … acetylene; ethylene;… TRUE               Yes           
#> 10 carlemsaph_00000005472318-001           carlemsaph                 france  pharmaceutical raw material 5c5d1cdb-22df-5e58-a3c7-500e031f03e7_dc1ed0ff-fbaa-47a1-8962… market for propylene … 2011        C20.… Manufacture… Manufacture of:high v… acetylene; ethylene;… TRUE               Yes           
#> # ℹ abbreviated names: ¹​ecoinvent_activity_name, ²​tax_activity_description
```

## Next steps

1.  Apply prototype to CPC classification products + Europages products.
2.  Clarify whether market activities can be eligible for EU Taxonomy
    activities starting with “Manufacture of…”?
3.  TBC how to validate “maybe” from GPT validation.
4.  Expand to all EU Taxonomy activities.
5.  Company-level results output share of products that are aligned, not
    aligned, NA,  
    transitional and enabling (“contribution type”).
6.  Optional: Include alignment assessment.
