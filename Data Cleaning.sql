select * from layoffs;
-- -----------------------creating a table same as layoffs
create table layoffs_stagging LIKE layoffs;

insert into layoffs_stagging select * from layoffs;

select * from layoffs_stagging;

-- ---------------------------------------1.remove duplicates
select *,row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num from layoffs_stagging;

with duplicate_cte as
(
select *,row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num from layoffs_stagging
)
select * from duplicate_cte where row_num>1;
select * from layoffs_stagging where company='Yahoo';
with duplicate_cte as
(
select *,row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num from layoffs_stagging
)
delete  from duplicate_cte where row_num>1;

CREATE TABLE `layoffs_stagging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


select * from layoffs_stagging2;

insert into layoffs_stagging2
select *,row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num from layoffs_stagging;

delete  from layoffs_stagging2 where row_num>1;
select * from layoffs_stagging2 where row_num>1;

-- ----------------------------------------------2.standardize the data
select company from layoffs_stagging2;
update layoffs_stagging2 set company=trim(company);

select distinct industry from layoffs_stagging2 order by 1;
select * from layoffs_stagging2 where industry like 'crypto%';
update layoffs_stagging2 set industry='Crypto' where industry like 'Crypto%';

select distinct location from layoffs_stagging2 order by 1;

select distinct country from layoffs_stagging2 order by 1;
select * from layoffs_stagging2 where country like 'United States%';
update layoffs_stagging2 set country=trim(trailing '.' from country) where country like 'United States%';

select `date`,str_to_date(`date`,'%m/%d/%y') from layoffs_stagging2;
update layoffs_stagging2  set `date`=str_to_date(`date`,'%m/%d/%Y');

Alter table layoffs_stagging2 modify `date` DATE;

-- ------------------------------------------------3.null/blank values
select * from  layoffs_stagging2 where industry is null or industry='';
select * from  layoffs_stagging2 where company='Airbnb';
Update layoffs_stagging2 set industry=null where industry='';
select t1.company,t1.industry,t2.company,t2.industry from layoffs_stagging2 t1 join layoffs_stagging2 t2 on t1.company=t2.company where t1.industry is null  and t2.industry is not null;

UPDATE layoffs_stagging2 t1
JOIN layoffs_stagging2 t2 
    ON t1.company = t2.company 
SET t1.industry = t2.industry  
WHERE t1.industry IS NULL  
AND t2.industry IS NOT NULL;


-- ------------------------------------------------4.Removing columns and rows(which are not needed)
SELECT *
FROM layoffs_stagging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE FROM layoffs_stagging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_stagging2
DROP COLUMN row_num;
select * from layoffs_stagging2;
