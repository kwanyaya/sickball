import { useEffect, useState } from 'react'

// Task Description: 
// This is a listing page of books.
// When the page is loaded, it fetches all books into a variable, called "books"
// Then user will do some searching, by typing some keywords or some tags
// The page will do the filtering locally and then store the result into a variable, called "shownItems"

// finish those "to do" parts
// p.s., you can add any other variables or functions you need

interface Book {
  id: string,
  name: string,
  tags: string[]
  // ... others
}

async function fetchAllBooks() {
  const list: Book[] = [
    { id: '1', name: 'xxx', tags: ['tag1', 'tag2'] },
    { id: '2', name: 'xxx2', tags: ['tag3', 'tag4'] },
    // ...
  ]
  return list
}

export default function MyPage() {
  const [books, setBooks] = useState<Book[]>()
  useEffect(() => {

  }, []) // to do
  
  const [page, setPage] = useState(1)
  const [keyword, setKeyword] = useState('')
  const [tagFilters, setTagFilters] = useState<string[]>([])
  useEffect(() => {

  }, []) // to do

  const shownItems: Book[] = [] // to do

  // ... no need to write the UI part
}