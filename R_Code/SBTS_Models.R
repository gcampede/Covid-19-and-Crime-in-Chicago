library("CausalImpact")


# preparation for causal impact (dates) - 1st wave up to march 16th
pre.period <- as.Date(c("2018-01-01", "2020-03-15"))
post.period <- as.Date(c("2020-03-16", "2020-05-14"))


#preparing Causal impact object to be looped through lists (1st WAVE)

resultList_bur = 
  lapply(
    burglary_zoo, 
    CausalImpact, 
    pre.period, 
    post.period,
    model.args = list(nseasons = 7, season.duration = 1)
  )

resultList_ass = 
  lapply(
    assault_zoo, 
    CausalImpact, 
    pre.period, 
    post.period,
    model.args = list(nseasons = 7, season.duration = 1)
  )

resultList_narco = 
  lapply(
    narco_zoo, 
    CausalImpact, 
    pre.period, 
    post.period,
    model.args = list(nseasons = 7, season.duration = 1)
  )

resultList_rob = 
  lapply(
    robbery_zoo, 
    CausalImpact, 
    pre.period, 
    post.period,
    model.args = list(nseasons = 7, season.duration = 1)
  )

