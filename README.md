
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tilt.eu.taxonomy

<!-- badges: start -->

[![R-CMD-check](https://github.com/2DegreesInvesting/tilt.eu.taxonomy/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/2DegreesInvesting/tilt.eu.taxonomy/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of tilt.eu.taxonomy is to assess whether each product of the
SME is eligible and aligned according to the activities which follow EU
taxonomy regulation objectives.

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

The products of each Europages company are mapped with the Ecoinvent
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

### Load Europages products mapped with Ecoinvent activities

This file is extracted from the dataframe `profile_companies` created by
the Python class `PCompanies` in the `tiltIndicatorBefore` repository.
It contains Europages products mapped with Ecoinevnt activities (along
with `isic_4digit`).

``` r
ep_products_ei_activities <- ep_companies_ei_activities |>
  select("ep_product", "ecoinvent_activity_name", "isic_4digit")  |>
  distinct()

ep_products_ei_activities |>
  slice(1:5)
#> # A tibble: 5 × 3
#>   ep_product           ecoinvent_activity_name                           isic_4digit
#>   <chr>                <chr>                                             <chr>      
#> 1 ptfe sealing gaskets sealing tape production, aluminium/PE, 50 mm wide 2220       
#> 2 bending              section bar rolling, steel                        2410       
#> 3 cutting              potato haulm cutting                              0161       
#> 4 ethyl alcohol        ethyl acetate production                          2011       
#> 5 phenols              phenol production, from cumene                    2011
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

These keywords are manually chosen and resemble the main domain of EU
Taxonomy activities. They are used to improve the quality of the match
between Ecoinevnt activities and EU Taxonomy activities by searching
each keyword in the mapped ecoinvent activity. Only those EU Taxonomy
activities are selected as good matches which have at least one keyword
present in the mapped ecoinvent activity.

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

NACE-ISIC sector mapper serves as the activity mapping bridge between
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
selected a small subset of taxonomy activities with keywords.

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

## Mapping NACE codes to Ecoinvent activities

To map Ecoinvent activities with EU Taxonomy activities, we will first
map the NACE sector codes to Ecoinvent activities using ISIC sector
codes present in both datasets `ep_products_ei_activities` and
`nace_isic_mapper`.

``` r
ecoinvent_activities_with_nace <- ecoinvent_activities_with_nace(ep_products_ei_activities, isic_nace_mapper)
ecoinvent_activities_with_nace |>
  slice(1:5)
#> # A tibble: 5 × 4
#>   ep_product           ecoinvent_activity_name                           isic_4digit NACE  
#>   <chr>                <chr>                                             <chr>       <chr> 
#> 1 ptfe sealing gaskets sealing tape production, aluminium/PE, 50 mm wide 2220        C22.21
#> 2 ptfe sealing gaskets sealing tape production, aluminium/PE, 50 mm wide 2220        C22.22
#> 3 ptfe sealing gaskets sealing tape production, aluminium/PE, 50 mm wide 2220        C22.23
#> 4 ptfe sealing gaskets sealing tape production, aluminium/PE, 50 mm wide 2220        C22.29
#> 5 bending              section bar rolling, steel                        2410        C24.10
```

## Mapping Ecoinvent activities (with NACE) to EU Taxonomy activities

NACE codes are used to map Ecoinvent activities and EU Taxonomy
activities. There is a one-to-many mapping between taxonomy activities
and Ecoinvent activities. This means that a single taxonomy activity can
be mapped to multiple ecoinvent activities.

``` r
ecoinvent_activities_eu_tax_activities <- ecoinvent_activities_eu_tax_activities(ecoinvent_activities_with_nace, eu_tax_activities_all_with_keywords)
ecoinvent_activities_eu_tax_activities
#> # A tibble: 253 × 7
#>    ep_product           ecoinvent_activity_name                           isic_4digit NACE   tax_activity                  tax_activity_description                                                                                                                                    tax_activity_keywords
#>    <chr>                <chr>                                             <chr>       <chr>  <chr>                         <chr>                                                                                                                                                       <chr>                
#>  1 ptfe sealing gaskets sealing tape production, aluminium/PE, 50 mm wide 2220        C22.21 <NA>                          <NA>                                                                                                                                                        <NA>                 
#>  2 ptfe sealing gaskets sealing tape production, aluminium/PE, 50 mm wide 2220        C22.22 <NA>                          <NA>                                                                                                                                                        <NA>                 
#>  3 ptfe sealing gaskets sealing tape production, aluminium/PE, 50 mm wide 2220        C22.23 <NA>                          <NA>                                                                                                                                                        <NA>                 
#>  4 ptfe sealing gaskets sealing tape production, aluminium/PE, 50 mm wide 2220        C22.29 <NA>                          <NA>                                                                                                                                                        <NA>                 
#>  5 bending              section bar rolling, steel                        2410        C24.10 Manufacture of iron and steel Manufacture of iron and steel. The economic activities in this category could be associated with several NACE codes, in particular C24.10, C24.20, C24.31,… iron; steel; ferrous…
#>  6 bending              section bar rolling, steel                        2410        C24.20 Manufacture of iron and steel Manufacture of iron and steel. The economic activities in this category could be associated with several NACE codes, in particular C24.10, C24.20, C24.31,… iron; steel; ferrous…
#>  7 bending              section bar rolling, steel                        2410        C24.31 Manufacture of iron and steel Manufacture of iron and steel. The economic activities in this category could be associated with several NACE codes, in particular C24.10, C24.20, C24.31,… iron; steel; ferrous…
#>  8 bending              section bar rolling, steel                        2410        C24.32 Manufacture of iron and steel Manufacture of iron and steel. The economic activities in this category could be associated with several NACE codes, in particular C24.10, C24.20, C24.31,… iron; steel; ferrous…
#>  9 bending              section bar rolling, steel                        2410        C24.33 Manufacture of iron and steel Manufacture of iron and steel. The economic activities in this category could be associated with several NACE codes, in particular C24.10, C24.20, C24.31,… iron; steel; ferrous…
#> 10 bending              section bar rolling, steel                        2410        C24.34 Manufacture of iron and steel Manufacture of iron and steel. The economic activities in this category could be associated with several NACE codes, in particular C24.10, C24.20, C24.31,… iron; steel; ferrous…
#> # ℹ 243 more rows
```

## Ecoinvent activities mapped with EU Taxonomy activities after keywords search

As there is one-to-many mapping between taxonomy activities and
Ecoinvent activities, there are high chance that we might get bad
matches between activities. Hence, `taxonomy_keywords` will be used to
check whether ecoinvent activities are a closer match to the mapped
taxonomy activity or not. If a single taxonomy keyword is present in the
`ecoinvent_activity_name` column then it is stated with “TRUE” in the
`keyword_is_present` column. Similarly, “FALSE” is stated if the keyword
is not present.

``` r
eco_activities_after_keywords_search <- eco_activities_after_keywords_search(ecoinvent_activities_eu_tax_activities)
eco_activities_after_keywords_search |>
  slice(1:10)
#> # A tibble: 10 × 8
#>    ep_product           ecoinvent_activity_name                           isic_4digit NACE   tax_activity                  tax_activity_description                                                                                                                 tax_activity_keywords keyword_is_present
#>    <chr>                <chr>                                             <chr>       <chr>  <chr>                         <chr>                                                                                                                                    <chr>                 <lgl>             
#>  1 ptfe sealing gaskets sealing tape production, aluminium/PE, 50 mm wide 2220        C22.21 <NA>                          <NA>                                                                                                                                     <NA>                  NA                
#>  2 ptfe sealing gaskets sealing tape production, aluminium/PE, 50 mm wide 2220        C22.22 <NA>                          <NA>                                                                                                                                     <NA>                  NA                
#>  3 ptfe sealing gaskets sealing tape production, aluminium/PE, 50 mm wide 2220        C22.23 <NA>                          <NA>                                                                                                                                     <NA>                  NA                
#>  4 ptfe sealing gaskets sealing tape production, aluminium/PE, 50 mm wide 2220        C22.29 <NA>                          <NA>                                                                                                                                     <NA>                  NA                
#>  5 bending              section bar rolling, steel                        2410        C24.10 Manufacture of iron and steel Manufacture of iron and steel. The economic activities in this category could be associated with several NACE codes, in particular C24.… iron; steel; ferrous… TRUE              
#>  6 bending              section bar rolling, steel                        2410        C24.20 Manufacture of iron and steel Manufacture of iron and steel. The economic activities in this category could be associated with several NACE codes, in particular C24.… iron; steel; ferrous… TRUE              
#>  7 bending              section bar rolling, steel                        2410        C24.31 Manufacture of iron and steel Manufacture of iron and steel. The economic activities in this category could be associated with several NACE codes, in particular C24.… iron; steel; ferrous… TRUE              
#>  8 bending              section bar rolling, steel                        2410        C24.32 Manufacture of iron and steel Manufacture of iron and steel. The economic activities in this category could be associated with several NACE codes, in particular C24.… iron; steel; ferrous… TRUE              
#>  9 bending              section bar rolling, steel                        2410        C24.33 Manufacture of iron and steel Manufacture of iron and steel. The economic activities in this category could be associated with several NACE codes, in particular C24.… iron; steel; ferrous… TRUE              
#> 10 bending              section bar rolling, steel                        2410        C24.34 Manufacture of iron and steel Manufacture of iron and steel. The economic activities in this category could be associated with several NACE codes, in particular C24.… iron; steel; ferrous… TRUE
```

## EU Taxonomy-eligible ecoinvent activities

The ecoinvent activities which have “TRUE” in the `keyword_is_present`
column are considered EU Taxonomy-eligible because they are matched with
EU Taxonomy activities after ISIC-NACE mapping and keywords search. Here
is a list of a small subset of EU Taxonomy-eligible ecoinvent
activities:

``` r
eco_activities_after_keywords_search |>
  filter(keyword_is_present == TRUE) |>
  slice(44:48)
#> # A tibble: 5 × 8
#>   ep_product                          ecoinvent_activity_name                                       isic_4digit NACE   tax_activity                            tax_activity_description                                                                             tax_activity_keywords keyword_is_present
#>   <chr>                               <chr>                                                         <chr>       <chr>  <chr>                                   <chr>                                                                                                <chr>                 <lgl>             
#> 1 specially designed expansion joints section bar rolling, steel                                    2410        C24.33 Manufacture of iron and steel           Manufacture of iron and steel. The economic activities in this category could be associated with se… iron; steel; ferrous… TRUE              
#> 2 specially designed expansion joints section bar rolling, steel                                    2410        C24.34 Manufacture of iron and steel           Manufacture of iron and steel. The economic activities in this category could be associated with se… iron; steel; ferrous… TRUE              
#> 3 rubber compensators                 isophthalic acid based unsaturated polyester resin production 2013        C20.16 Manufacture of plastics in primary form Manufacture resins, plastics materials and non-vulcanisable thermoplastic elastomers, the mixing an… resin; plastic; ther… TRUE              
#> 4 chlorine for water                  market for chlorine, gaseous                                  2011        C20.13 Manufacture of chlorine                 Manufacture of chlorine.The economic activities in this category could be associated with NACE code… chlorine; sodium chl… TRUE              
#> 5 hand tools, non-power               market for forging, steel                                     2410        C24.10 Manufacture of iron and steel           Manufacture of iron and steel. The economic activities in this category could be associated with se… iron; steel; ferrous… TRUE
```
