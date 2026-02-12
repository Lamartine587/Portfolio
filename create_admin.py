from app import app, db, User
from werkzeug.security import generate_password_hash

def create_admin_user():
    username = input("Enter Admin Username: ")
    password = input("Enter Admin Password: ")
    
    with app.app_context():
        if User.query.filter_by(username=username).first():
            print("Error: User already exists.")
            return

        hashed_pw = generate_password_hash(password, method='pbkdf2:sha256')
        new_user = User(username=username, password=hashed_pw)
        
        db.session.add(new_user)
        db.session.commit()
        print(f"User '{username}' created successfully!")

if __name__ == "__main__":
    create_admin_user()