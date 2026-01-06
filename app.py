import os

from flask import Flask, render_template, request

app = Flask(__name__)

from global_func import get_data, cron


@app.route('/', methods=["GET", "POST", "PATCH", "PUT", "DELETE"])
def index():
    if request.method == "POST":
        try:
            par = request.values
            job = cron.new(command=par['command'])
            job.comment = par['comment']
            job.setall(" ".join([par['minute'], par['hour'], par['date'], par['month'], par['day']]))
            cron.write()
            return {"status": "success"}
        except Exception as e:
            print(e)
            return {"status": "error"}, 500
    elif request.method == "PATCH":
        try:
            par = request.values
            for job in cron:
                if str(job.slices) == par.get("schedule") and job.command == par.get("command") and job.comment == par.get("comment"):
                    job.enable(par.get("status") == "activate")
            cron.write()
            return {"status": "success"}
        except Exception as e:
            print(e)
            return {"status": "error"}, 500
    elif request.method == "PUT":
        try:
            par = request.values
            for job in cron:
                if job.command == par.get("oldCommand") and job.comment == par.get("oldComment"):
                    job.command = par['command']
                    job.comment = par['comment']
                    job.setall(" ".join([par['minute'], par['hour'], par['date'], par['month'], par['day']]))
            cron.write()
            return {"status": "success"}
        except Exception as e:
            print(e)
            return {"status": "error"}, 500
    elif request.method == "DELETE":
        try:
            par = request.values
            for job in cron:
                if str(job.slices) == par.get("schedule") and job.command == par.get("command") and job.comment == par.get("comment"):
                    cron.remove(job)
            cron.write()
            return {"status": "success"}
        except Exception as e:
            print(e)
            return {"status": "error"}, 500
    data = get_data()
    return render_template("index.html", data=data)


if __name__ == '__main__':
    app.run(port=9090)
