import firebase_admin
from firebase_admin import credentials, firestore

# Initialize Firebase Admin SDK
cred = credentials.Certificate('../firebase_key/sakajobapp-firebase-adminsdk-d48ri-cdc91ebaaa.json')  # Update with the path to your service account key
firebase_admin.initialize_app(cred)

db = firestore.client()

jobs = [
    {
        'category': 'Service',
        'dateposted': '2024-07-16',
        'description': 'Maintain order and cleanliness in the office premises',
        'employment': 'Full-time',
        'experience': 'Entry-level',
        'imageUrl': 'https://static01.nyt.com/images/2020/03/20/opinion/20Land/20Land-articleLarge.jpg?quality=75&auto=webp&disable=upscale',
        'location': 'Mombasa, Kenya',
        'salary': '7,000 - 15,000',
        'title': 'Office Cleaner'
    },
]

# Batch write to Firestore
batch = db.batch()

for job in jobs:
    job_ref = db.collection('jobs').document()
    batch.set(job_ref, job)

# Commit the batch
try:
    batch.commit()
    print('Jobs added successfully.')
except Exception as e:
    print(f'Error adding jobs: {e}')
