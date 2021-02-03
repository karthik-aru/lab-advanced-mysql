use publications;


-- Challenge 1 - Most Profiting Authors
-- Step 1: Calculate the royalty of each sale for each author and the advance for each author and publication

select ti.title_id as TITLE_ID, ta.au_id as AUTHOR_ID, ti.advance*ta.royaltyper/100 as advance, ti.price*s.qty*ti.royalty/100*ta.royaltyper/100 as sales_royalty
from titles ti
join
	titleauthor ta on ti.title_id = ta.title_id
left join
	sales s on ti.title_id = s.title_id;

-- Step 2: Aggregate the total royalties for each title and author
select TITLE_ID, AUTHOR_ID, advance, sum(sales_royalty) AS royalty_per_ta
FROM (
select ti.title_id as TITLE_ID, ta.au_id as AUTHOR_ID, ti.advance*ta.royaltyper/100 as advance, ti.price*s.qty*ti.royalty/100*ta.royaltyper/100 as sales_royalty
from titles ti
join
	titleauthor ta on ti.title_id = ta.title_id
left join
	sales s on ti.title_id = s.title_id) AS tab1
group by AUTHOR_ID, TITLE_ID, advance;

-- Step 3: Calculate the total profits of each author
select AUTHOR_ID, round(sum(advance)+sum(royalty_per_ta), 1) AS PROFITS
from (
select TITLE_ID, AUTHOR_ID, advance, sum(sales_royalty) AS royalty_per_ta
FROM (
select ti.title_id as TITLE_ID, ta.au_id as AUTHOR_ID, ti.advance*ta.royaltyper/100 as advance, ti.price*s.qty*ti.royalty/100*ta.royaltyper/100 as sales_royalty
from titles ti
join
	titleauthor ta on ti.title_id = ta.title_id
left join
	sales s on ti.title_id = s.title_id) AS tab1
group by AUTHOR_ID, TITLE_ID, advance) tab2
group by AUTHOR_ID
order by PROFITS DESC
limit 3;

-- Challenge 2

Create temporary table tab1
select ti.title_id as TITLE_ID, ta.au_id as AUTHOR_ID, ti.advance*ta.royaltyper/100 as advance, ti.price*s.qty*ti.royalty/100*ta.royaltyper/100 as sales_royalty
from titles ti
join
	titleauthor ta on ti.title_id = ta.title_id
left join
	sales s on ti.title_id = s.title_id;

create temporary table tab2
select TITLE_ID, AUTHOR_ID, advance, sum(sales_royalty) AS royalty_per_ta
from tab1
group by AUTHOR_ID, TITLE_ID, advance;

select AUTHOR_ID, round(sum(advance)+sum(royalty_per_ta), 1) AS PROFITS
from tab2
group by AUTHOR_ID
order by PROFITS DESC
limit 3;

-- Challenge 3
create table publications.most_profiting_authors
select AUTHOR_ID, round(sum(advance)+sum(royalty_per_ta), 1) AS PROFITS
from tab2
group by AUTHOR_ID
order by PROFITS DESC
limit 3;
