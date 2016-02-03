--Лемма - Слово в других регистрах (casedwords)
--Например admiralty island это остров и пишется с большой буквы Admiralty Island
select
     a.wordid
    ,a.lemma
    ,cw.cased lemma_cased
from words a
--Слово в других регистрах
JOIN casedwords cw on cw.wordid = a.wordid
order by a.lemma

--Лемма - Грамматические формы слова - inflections - (morphs)
--Например от abhor образуются abhorred, abhorring
select
     a.wordid
    ,a.lemma
    ,m.morph
    ,pt2.posname
from words a
--Грамматические формы слова
join morphmaps mm on a.wordid = mm.wordid
join morphs m on m.morphid = mm.morphid
left join postypes pt2 on pt2.pos = mm.pos
--where a.lemma like 'able%'
order by a.lemma

--Лемма - группы слов (lexdomains) - например animal, body
select
     a.wordid
    ,a.lemma
    ,b.sensenum
    ,l.lexdomainname
    ,l.lexdomain
    ,l.pos as pos_lexdomain
    ,pt.posname as posname_lexdomain
    ,c.definition
from words a
--Значения слова
join senses b on b.wordid = a.wordid
join synsets c on c.synsetid = b.synsetid
--группы слов
join lexdomains l on l.lexdomainid = c.lexdomainid
--Часть речи группы слов
left join postypes pt on pt.pos = l.pos
where a.lemma like 'able%'
order by a.lemma, b.sensenum

--Лемма - Значения слова (senses)
select
     a.wordid
    ,a.lemma
    ,b.sensenum
    ,c.pos
    ,pt.posname
    ,c.definition
from words a
--Значения слова
join senses b on b.wordid = a.wordid
join synsets c on c.synsetid = b.synsetid
--Части речи
left join postypes pt on pt.pos = c.pos
where a.lemma = 'able' 
order by a.lemma, b.sensenum

--Связи - Синонимы
select
w.wordid
,w.lemma
,w2.wordid
,w2.lemma
,sy.definition
from words w
join senses s1 on s1.wordid = w.wordid
left join synsets sy on sy.synsetid = s1.synsetid
join senses s2 on s2.synsetid = s1.synsetid
join words w2 on w2.wordid = s2.wordid
where w.wordid != w2.wordid and w.lemma = 'angry'

--Связи (hypernym, hyponym, similar, attribute и т.д.)
select distinct
w.wordid
,w.lemma
,w2.wordid
,w2.lemma
,lt.link
,sy.definition
from words w
join senses s1 on s1.wordid = w.wordid
left join synsets sy on sy.synsetid = s1.synsetid
join semlinks sem on sem.synset1id = s1.synsetid
join senses s2 on s2.synsetid = sem.synset2id
left join linktypes lt on lt.linkid = sem.linkid
join words w2 on w2.wordid = s2.wordid
WHERE w.lemma = 'able' 
ORDER BY s1.sensenum

--Связи (antonym, pertainym, derivation, also и т.д.)
select distinct
w.wordid
,w.lemma
,w2.wordid
,w2.lemma
,lt.link
,sy.definition
from words w
join senses s1 on s1.wordid = w.wordid
left join synsets sy on sy.synsetid = s1.synsetid
join lexlinks sem on sem.synset1id = s1.synsetid
join senses s2 on s2.synsetid = sem.synset2id
left join linktypes lt on lt.linkid = sem.linkid
join words w2 on w2.wordid = s2.wordid
WHERE w.lemma = 'able' 
ORDER BY s1.sensenum

--============================================================================
SELECT link, COUNT(*) 
FROM lexlinks 
LEFT JOIN linktypes USING(linkid) 
GROUP BY linkid ORDER BY COUNT(*) desc

SELECT link, COUNT(*) 
FROM semlinks 
LEFT JOIN linktypes USING(linkid) 
GROUP BY linkid ORDER BY COUNT(*) desc

select b.*, c.*
from senses b
join synsets c on c.synsetid = b.synsetid
where c.lexdomainid is not null
limit 1000

select * from linktypes limit 100

select * from senses where wordid = 4410









