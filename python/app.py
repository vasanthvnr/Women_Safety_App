from flask import Flask, render_template, request, redirect, url_for, flash
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

# Secret key for session management
app.secret_key = "your_secret_key"

# Database configuration
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:root@localhost:5432/vasanth'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Initialize the database
db = SQLAlchemy(app)

# Database model
class Alert(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), nullable=False)
    mobile = db.Column(db.String(15), nullable=False)
    email = db.Column(db.String(100), nullable=False)
    location = db.Column(db.String(100), nullable=False)
    message = db.Column(db.String(255), nullable=False)

# Route for login page
@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        # Hardcoded credentials for login
        if username == 'admin' and password == '12345':
            flash('Login successful!', 'success')
            return redirect(url_for('index'))
        else:
            flash('Invalid username or password!', 'danger')

    return render_template('login.html')

# Route for index page
@app.route('/index')
def index():
    alerts = Alert.query.all()  # Fetch all alerts from the database
    return render_template('index.html', alerts=alerts)

# Route to add a new alert
@app.route('/add_alert', methods=['POST'])
def add_alert():
    if request.method == 'POST':
        username = request.form['username']
        mobile = request.form['mobile']
        email = request.form['email']
        location = request.form['location']
        message = request.form['message']

        new_alert = Alert(username=username, mobile=mobile, email=email, location=location, message=message)
        db.session.add(new_alert)
        db.session.commit()
        flash('Alert added successfully!', 'success')

    return redirect(url_for('index'))

# Route to delete an alert
@app.route('/delete_alert/<int:id>')
def delete_alert(id):
    alert = Alert.query.get_or_404(id)
    db.session.delete(alert)
    db.session.commit()
    flash('Alert deleted successfully!', 'success')

    return redirect(url_for('index'))

# Ensure database tables exist before running the app
with app.app_context():
    db.create_all()

if __name__ == '__main__':
    app.run(debug=True)
