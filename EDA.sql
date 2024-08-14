-- Exploratory Data analysis
select * from layoffs_stagging2;

SELECT MAX(total_laid_off)
FROM world_layoffs.layoffs_staging2;

SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM layoffs_staging2
WHERE  percentage_laid_off IS NOT NULL;

SELECT *
FROM layoffs_stagging2
WHERE  percentage_laid_off = 1 
ORDER BY total_laid_off DESC;

SELECT *
FROM layoffs_stagging2
WHERE  percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

select company,sum(total_laid_off) from layoffs_stagging2 group by company order by 2 desc;

SELECT location, SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;

SELECT country, SUM(total_laid_off)
FROM world_layoffs.layoffs_stagging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(date), SUM(total_laid_off)
FROM world_layoffs.layoffs_stagging2
GROUP BY YEAR(date)
ORDER BY 1 ASC;

SELECT industry, SUM(total_laid_off)
FROM world_layoffs.layoffs_stagging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT stage, SUM(total_laid_off)
FROM world_layoffs.layoffs_stagging2
GROUP BY stage
ORDER BY 1 DESC;

select min(`date`),max(`date`) FROM layoffs_stagging2;
select substring(`date`,6,2) as `month`, SUM(total_laid_off)  FROM layoffs_stagging2 where substring(`date`,6,2) is not null GROUP BY `month`;

select substring(`date`,1,7) as `month`, SUM(total_laid_off)  
FROM layoffs_stagging2 
where substring(`date`,1,7) is not null 
GROUP BY `month`
order by 1 asc;


with Rolling_total as
(
select substring(`date`,1,7) as `month`, SUM(total_laid_off)  as total_off
FROM layoffs_stagging2 
where substring(`date`,1,7) is not null 
GROUP BY `month`
order by 1 asc
)
SELECT `month`,total_off, SUM(total_off) OVER (ORDER BY `month`) as rolling_total
FROM Rolling_total;

select company,Year(`date`),sum(total_laid_off)  
FROM layoffs_stagging2 
group by company,Year(`date`)
order by company asc;

with company_year (company,years,total_laid_off) as
(
select company,Year(`date`),sum(total_laid_off)  
FROM layoffs_stagging2 
group by company,Year(`date`)
),
company_year_rank as
(SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM company_year
  where years is not null
   )
   select * from company_year_rank
   where ranking<=5;
