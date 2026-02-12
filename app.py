import os
from flask import Flask, render_template, request, redirect, url_for, flash
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
from flask_mail import Mail, Message as MailMessage
from werkzeug.security import generate_password_hash, check_password_hash
from dotenv import load_dotenv

# --- CONFIGURATION ---
load_dotenv()

app = Flask(__name__)
app.secret_key = os.getenv('SECRET_KEY', 'dev_key_fallback')

# Database Config
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URL', 'sqlite:///portfolio.db')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Mail Config (Pulling from your .env)
app.config['MAIL_SERVER'] = os.getenv('MAIL_SERVER')
app.config['MAIL_PORT'] = int(os.getenv('MAIL_PORT') or 587)
app.config['MAIL_USE_TLS'] = os.getenv('MAIL_USE_TLS') == 'True'
app.config['MAIL_USERNAME'] = os.getenv('MAIL_USERNAME')
app.config['MAIL_PASSWORD'] = os.getenv('MAIL_PASSWORD')

db = SQLAlchemy(app)
mail = Mail(app) # This will now work because of the import above

# Login Config
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'

# --- MODELS ---
class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(150), unique=True, nullable=False)
    password = db.Column(db.String(255), nullable=False)

class Project(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    github_link = db.Column(db.String(200), nullable=True)
    icon = db.Column(db.String(50), default='fas fa-code')
    color = db.Column(db.String(20), default='#10b981')
    status = db.Column(db.String(20), default='In Progress')
    
    @property
    def status_class(self):
        return "status-upcoming" if self.status != "Completed" else ""

class ContactInquiry(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(100), nullable=False)
    message = db.Column(db.Text, nullable=False)
    timestamp = db.Column(db.DateTime, default=db.func.now())

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

# --- PUBLIC ROUTES ---
@app.route('/')
def home():
    projects = Project.query.all()
    return render_template('index.html', projects=projects)

@app.route('/contact', methods=['POST'])
def contact():
    name = request.form.get('name')
    email = request.form.get('email')
    message_body = request.form.get('message')
    
    try:
        new_inquiry = ContactInquiry(name=name, email=email, message=message_body)
        db.session.add(new_inquiry)
        db.session.commit()
    except Exception as e:
        print(f"Database error: {e}")

    msg = MailMessage(
        subject=f"New Portfolio Message from {name}",
        sender=app.config['MAIL_USERNAME'],
        recipients=[os.getenv('RECEIVER_EMAIL')],
        body=f"Sender: {name}\nEmail: {email}\n\nMessage:\n{message_body}"
    )
    
    try:
        mail.send(msg)
        flash(f"Thank you, {name}! Your message has been sent.")
    except Exception as e:
        print(f"Mail error: {e}")
        flash("Message saved to database, but email notification failed.")
        
    return redirect(url_for('home') + "#contact")

# --- ADMIN ROUTES ---
@app.route('/login', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('admin'))
    if request.method == 'POST':
        user = User.query.filter_by(username=request.form.get('username')).first()
        if user and check_password_hash(user.password, request.form.get('password')):
            login_user(user)
            return redirect(url_for('admin'))
        flash('Invalid username or password.')
    return render_template('login.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('home'))

@app.route('/admin')
@login_required
def admin():
    projects = Project.query.all()
    inquiries = ContactInquiry.query.order_by(ContactInquiry.timestamp.desc()).all()
    return render_template('admin.html', projects=projects, inquiries=inquiries, name=current_user.username)

@app.route('/admin/add', methods=['GET', 'POST'])
@login_required
def add_project():
    if request.method == 'POST':
        new_project = Project(
            title=request.form.get('title'),
            description=request.form.get('description'),
            github_link=request.form.get('github_link'),
            icon=request.form.get('icon'),
            color=request.form.get('color'),
            status=request.form.get('status')
        )
        db.session.add(new_project)
        db.session.commit()
        flash('Project added successfully!')
        return redirect(url_for('admin'))
    return render_template('add_project.html')

@app.route('/admin/edit/<int:id>', methods=['GET', 'POST'])
@login_required
def edit_project(id):
    project = Project.query.get_or_404(id)
    if request.method == 'POST':
        project.title = request.form.get('title')
        project.description = request.form.get('description')
        project.github_link = request.form.get('github_link')
        project.icon = request.form.get('icon')
        project.color = request.form.get('color')
        project.status = request.form.get('status')
        db.session.commit()
        flash('Project updated!')
        return redirect(url_for('admin'))
    return render_template('edit_project.html', project=project)

@app.route('/admin/delete/<int:id>')
@login_required
def delete_project(id):
    project = Project.query.get_or_404(id)
    db.session.delete(project)
    db.session.commit()
    flash('Project deleted.')
    return redirect(url_for('admin'))

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True, use_reloader=False)