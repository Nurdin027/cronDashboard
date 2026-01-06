USER_NAME = $(shell whoami)
PROJECT_DIR = $(shell pwd)
PYTHON_BIN = $(PROJECT_DIR)/.venv/bin
SERVICE_FILE = crondashboard.service
SYSTEMD_DIR = /etc/systemd/system

.PHONY: install dev setup-logs deploy reload logs status stop

install:
	uv sync

dev:
	uv run app.py

setup-logs:
	@echo "Creating log directory..."
	sudo mkdir -p /var/log/crondashboard
	sudo chown -R $(USER_NAME):$(USER_NAME) /var/log/crondashboard
	sudo touch /var/log/crondashboard/access.log /var/log/crondashboard/error.log
	@echo "Log directory ready."

deploy: setup-logs
	@echo "Generating systemd service file..."
	@echo "[Unit]" > $(SERVICE_FILE)
	@echo "Description=Gunicorn instance to serve CronDashboard" >> $(SERVICE_FILE)
	@echo "After=network.target" >> $(SERVICE_FILE)
	@echo "" >> $(SERVICE_FILE)
	@echo "[Service]" >> $(SERVICE_FILE)
	@echo "User=$(USER_NAME)" >> $(SERVICE_FILE)
	@echo "Group=$(USER_NAME)" >> $(SERVICE_FILE)
	@echo "WorkingDirectory=$(PROJECT_DIR)" >> $(SERVICE_FILE)
	@echo "Environment=\"PATH=$(PYTHON_BIN)\"" >> $(SERVICE_FILE)
	@echo "ExecStart=$(PYTHON_BIN)/gunicorn --workers 4 --bind 127.0.0.1:9090 --access-logfile /var/log/crondashboard/access.log --error-logfile /var/log/crondashboard/error.log app:app" >> $(SERVICE_FILE)
	@echo "" >> $(SERVICE_FILE)
	@echo "[Install]" >> $(SERVICE_FILE)
	@echo "WantedBy=multi-user.target" >> $(SERVICE_FILE)

	@echo "Installing service..."
	sudo mv $(SERVICE_FILE) $(SYSTEMD_DIR)/$(SERVICE_FILE)
	sudo systemctl daemon-reload
	sudo systemctl enable crondashboard
	sudo systemctl restart crondashboard
	@echo "Deployment success! Service is running."

reload:
	sudo systemctl restart crondashboard
	@echo "Service restarted."

logs:
	tail -f /var/log/crondashboard/access.log /var/log/crondashboard/error.log

status:
	sudo systemctl status crondashboard

stop:
	sudo systemctl stop crondashboard