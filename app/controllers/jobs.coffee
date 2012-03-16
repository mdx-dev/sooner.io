models = require __dirname + '/../models'
Paginator = require __dirname + '/../../lib/paginator'

module.exports =

  index: (req, res) ->
    models.job.find {}, (err, jobs) ->
      if(err)
        res.send 'error retreiving jobs', 500
      else
        res.render 'jobs/index.jade',
          jobs: jobs

  show: (req, res) ->
    models.job.findById req.params.id, (err, job) ->
      if err
        res.send 'Not found', 404
      else
        query = models.run.where('jobId', job._id)
        new Paginator perPage: 10, page: req.query.page, query: query, (paginator) ->
          query.skip(paginator.skip).limit(paginator.limit).desc('ranAt').run (err, runs) ->
            if err
              runs = []
            res.render 'jobs/show.jade',
              job: job
              runs: runs
              paginator: paginator

  new: (req, res) ->
    job = new models.job()
    res.render 'jobs/new.jade',
      job: job

  create: (req, res) ->
    job = new models.job()
    job.updateAttributes(req.body)
    job.save (err) ->
      if err
        job.errors = err.errors
        res.render 'jobs/new.jade',
          job: job
      else
        GLOBAL.hook.emit 'reload-jobs'
        res.redirect("/jobs/#{job._id}")

  edit: (req, res) ->
    models.job.findById req.params.id, (err, job) ->
      if err
        res.send 'Not found', 404
      else
        res.render 'jobs/edit.jade',
          job: job

  update: (req, res) ->
    models.job.findById req.params.id, (err, job) ->
      if err
        res.send 'Not found', 404
      else
        job.updateAttributes(req.body)
        job.save (err) ->
          if err
            job.errors = err.errors
            res.render 'jobs/edit.jade',
              job: job
          else
            GLOBAL.hook.emit 'reload-jobs'
            res.redirect("/jobs/#{job._id}")

  delete: (req, res) ->
    models.job.remove {_id: req.params.id}, (err) ->
      if err
        res.send err, 404
      else
        res.redirect("/jobs")
